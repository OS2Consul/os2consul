# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'users', 'registrations_controller').to_s

class Users::RegistrationsController < Devise::RegistrationsController
  def new
    # Disable user self-registration
    redirect_to new_user_session_path
  end

  def delete
    # Disable account removal (might result in double votes)
    raise NotImplementedError
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

  def delete_form
    # Disable account removal (might result in double votes)
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

    token, mnemo = params.require(%i[token mnemo])
    pid, name = get_pid_and_name(token, mnemo)

    if pid.blank?
      flash[:error] = t('devise.failure.timeout')
      return redirect_to authenticated_return_url
    end

    # Sign the user into Consul
    sign_in(:user, find_or_create_user(pid, name))

    # Sign out from nemlogin before proceeding, since the necessary
    # information has been collected
    redirect_to nemlogin_destroy_session_url(
      URI.join(root_url, authenticated_return_url)
    ), notice: t('devise.sessions.signed_in')
  end

  private

  def get_pid_and_name(token, mnemo)
    # Obtains the user PID and name from nemlogin through a SOAP API
    client = Savon.client(wsdl: Rails.application.secrets.nemlogin_wsdl_uri)
    response = client.call(:log_in, message: { token: token, mnemo: mnemo }).to_hash

    status = response.dig(:log_in_response, :log_in_result, :ok)

    return nil unless status

    [response.dig(:log_in_response, :log_in_result, :pid),
     response.dig(:log_in_response, :log_in_result, :name)]
  end

  def find_or_create_user(pid, name)
    user = User.find_for_authentication(username: pid)

    if user.present?
      user.fullname = name
      user.save
    else
      user = User.create!(
        username: pid,
        fullname: name,
        email: "#{pid}@nemlogin",
        confirmed_at: Time.current,
        newsletter: false,
        email_on_proposal_notification: false,
        email_digest: false,
        email_on_direct_message: false,
        email_on_comment: false,
        email_on_comment_reply: false,
        terms_of_service: '1',
        residence_verified_at: Time.current,
        verified_at: Time.current
      )
    end

    user
  end

  def nemlogin_destroy_session_url(callback)
    uri = URI(Rails.application.secrets.nemlogin_logout_uri)
    uri.query = { RelayState: callback }.to_query
    uri.to_s
  end

  def authenticated_return_url
    session[stored_location_key_for(:user)] || root_path
  end
end
