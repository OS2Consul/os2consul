# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'users', 'registrations_controller').to_s

class Users::RegistrationsController < Devise::RegistrationsController
  def new
    # Disable user self-registration
    redirect_to new_user_session_path
  end

  alias original_update update
  def update
    # Disable password change for non-administrators
    return original_update if current_user.administrator?

    raise NotImplementedError
  end

  def create
    # Disable user self-registration
    raise NotImplementedError
  end

  def finish_signup
    # Disable user self-registration
    raise NotImplementedError
  end

  def do_finish_signup
    # Disable user self-registration
    raise NotImplementedError
  end

  def check_username
    # Disable user self-registration
    raise NotImplementedError
  end

  def destroy
    # Disable user self-registration
    raise NotImplementedError
  end

  def cancel
    # Disable user self-registration
    raise NotImplementedError
  end

  alias original_edit edit
  def edit
    # Disable password change for non-administrators
    if current_user.administrator?
      original_edit
    else
      raise NotImplementedError
    end
  end

  def success
    # This is the action that the user is redirected to after using
    # nemlogin for authentication
    return redirect_to authenticated_return_url if user_signed_in?

    encryptor = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31])

    if params.key?(:user)
      @user = User.new(params.require(:user).permit(:registration_state, :terms_of_service, :consent_and_information))
      @residence_valid = true

      state = ActiveSupport::JSON.decode(encryptor.decrypt_and_verify(@user.registration_state)).symbolize_keys

      @user.assign_attributes(
        username: state[:pid],
        fullname: state[:name],
        email: "#{state[:pid]}@nemlogin",
        confirmed_at: Time.current,
        newsletter: false,
        email_on_proposal_notification: false,
        email_digest: false,
        email_on_direct_message: false,
        email_on_comment: false,
        email_on_comment_reply: false,
        residence_verified_at: Time.current,
        verified_at: Time.current
      )

      if !params[:initial_prompt] && @user.valid?
        @user.save

        finalize_sign_in(@user)
      end
    else
      token, mnemo = params.require(%i[token mnemo])
      pid, name, cpr = get_pid_and_name(token, mnemo)

      if enable_serviceplatformen?
        doc = request_serviceplatformen(cpr)

        if doc.nil?
          @residence_valid = false
        else
          name = serviceplatformen_name(doc)

          if Rails.application.secrets.serviceplatformen_kommunekode_valid_for_residence.present?
            @residence_valid = check_residence(doc)
          end
        end
      end

      if pid.blank?
        flash[:error] = t('devise.failure.timeout')
        return redirect_to authenticated_return_url
      end

      if @residence_valid
        @user = User.find_for_authentication(username: pid)

        if @user.present?
          @user.fullname = name
          @user.save

          finalize_sign_in(@user)
        else
          redirect_to users_sign_up_success_path(
            initial_prompt: true,
            user: {
              registration_state: encryptor.encrypt_and_sign({ pid: pid, name: name }.to_json)
            }
          )
        end
      end
    end
  end

  private

  def finalize_sign_in(_user)
    # Sign the user into Consul
    sign_in(:user, @user)

    # Sign out from nemlogin before proceeding, since the necessary
    # information has been collected
    redirect_to nemlogin_destroy_session_url(
      URI.join(root_url, authenticated_return_url)
    ), notice: t('devise.sessions.signed_in')
  end

  def get_pid_and_name(token, mnemo)
    # Obtains the user PID and name from MitID through a REST API

    # Prepare a connection to the REST API
    client = Net::HTTP.new(Rails.application.secrets.nemlogin_rest_uri, 443)
    # Use SSL
    client.use_ssl = true

    # Prepare a new POST request to the REST APIs login service
    request = Net::HTTP::Post.new(Rails.application.secrets.nemlogin_login_service_uri)
    # Prepare form data, one containing the token and one the mnemo key
    request.set_form_data({ "token": token, "mnemo": mnemo })
    # Send the POST request
    response = client.request(request)

    # Read the response body, and parse the returned JSON.
    json_response = JSON.parse(response.body)

    # Return nil if 'ok' is false
    return nil unless json_response['ok']

    # Return the required data
    [json_response['pid'],
     json_response['name'],
     json_response['cpr']]
  end

  def enable_serviceplatformen?
    return false if Rails.application.secrets.serviceplatformen_host.blank?
    return false if Rails.application.secrets.serviceplatformen_cert_path.blank?
    return false if Rails.application.secrets.serviceplatformen_key_path.blank?
    return false if Rails.application.secrets.serviceplatformen_service_agreement_uuid.blank?
    return false if Rails.application.secrets.serviceplatformen_user_system_uuid.blank?
    return false if Rails.application.secrets.serviceplatformen_user_uuid.blank?
    return false if Rails.application.secrets.serviceplatformen_service_uuid.blank?
    true
  end

  def request_serviceplatformen(cpr)
    http = Net::HTTP.start(
      Rails.application.secrets.serviceplatformen_host,
      443,
      use_ssl: true,
      cert: OpenSSL::X509::Certificate.new(File.read(Rails.application.secrets.serviceplatformen_cert_path)),
      key: OpenSSL::PKey::RSA.new(File.read(Rails.application.secrets.serviceplatformen_key_path)),
    )

    request = Net::HTTP::Post.new("/service/CPR/PersonBaseDataExtended/5")
    request.body = <<-XML.strip_heredoc
      <?xml version="1.0" encoding="UTF-8"?>
      <env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tns="http://serviceplatformen.dk/xml/wsdl/soap11/CPR/PersonBaseDataExtended/5/" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cpr="http://serviceplatformen.dk/xml/schemas/cpr/PNR/1/" xmlns:invctx="http://serviceplatformen.dk/xml/schemas/InvocationContext/1/">
        <env:Body>
          <tns:PersonLookupRequest>
            <cpr:PNR>#{cpr}</cpr:PNR>
            <invctx:InvocationContext>
              <ServiceAgreementUUID>#{Rails.application.secrets.serviceplatformen_service_agreement_uuid}</ServiceAgreementUUID>
              <UserSystemUUID>#{Rails.application.secrets.serviceplatformen_user_system_uuid}</UserSystemUUID>
              <UserUUID>#{Rails.application.secrets.serviceplatformen_user_uuid}</UserUUID>
              <ServiceUUID>#{Rails.application.secrets.serviceplatformen_service_uuid}</ServiceUUID>
              <AccountingInfo>#{Rails.application.secrets.serviceplatformen_accounting_info}</AccountingInfo>
            </invctx:InvocationContext>
          </tns:PersonLookupRequest>
        </env:Body>
      </env:Envelope>
    XML
    request.content_type = 'text/xml'

    # logger.info "Requesting serviceplatformen:"
    # logger.info request.body

    response = http.request(request)

    # logger.info "Serviceplatformen response:"
    # logger.info response.body

    doc = Nokogiri::XML(response.body, nil, "iso-8859-1")
    doc.remove_namespaces!
    doc
  rescue Exception => e
    logger.error "Serviceplatformen error:"
    logger.error e.message
    nil
  end

  def check_residence(doc)
    kommunekode = doc.at_xpath('//adresse/aktuelAdresse/kommunekode').text.to_i

    Rails.application.secrets.serviceplatformen_kommunekode_valid_for_residence.split(',').map(&:strip).map(&:to_i).include? kommunekode
  end

  def serviceplatformen_name(doc)
    doc.at_xpath('//persondata/navn/personadresseringsnavn').text
  end

  def nemlogin_destroy_session_url(callback)
    uri = URI(Rails.application.secrets.nemlogin_logout_uri)
    uri.query = { RelayState: callback }.to_query
    uri.to_s
  end

  def authenticated_return_url
    if current_user.email.match(/@nemlogin/)
      account_path
    else
      session[stored_location_key_for(:user)] || root_path
    end
  end
end
