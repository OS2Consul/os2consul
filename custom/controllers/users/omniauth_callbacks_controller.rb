# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'users', 'omniauth_callbacks_controller').to_s

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token

  def facebook
    # Disable third-party authentication
    raise NotImplementedError
  end

  def twitter
    # Disable third-party authentication
    raise NotImplementedError
  end

  def google_oauth2
    # Disable third-party authentication
    raise NotImplementedError
  end

  def saml
    Rails.logger.debug "Initiating saml login"
    auth = request.env["omniauth.auth"]

    # Fetching user data from attributes.
    attributes = auth.extra.response_object.attributes
    username = if [true, 1, 'true', '1'].include? Rails.application.secrets.saml_use_email_as_nameid
                 attributes['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'].first
               else
                 attributes['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'].first
               end
    fullname = attributes['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'].first
    email = attributes['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'].first

    # Requires OneLogin::RubySaml::Attributes.single_value_compatibility = false in config/initializers/omniauth-saml.rb
    groups = auth.extra.response_object.attributes['http://schemas.xmlsoap.org/claims/Group']

    user = User.find_by(email: email) || User.new(
      username: username,
      fullname: fullname,
      email: email,
      oauth_email: email,
      password: Devise.friendly_token[0, 20],
      confirmed_at: Time.current,
      residence_verified_at: Time.current,
      verified_at: Time.current,
      terms_of_service: '1',
      consent_and_information: '1'
    )

    if user.save
      Rails.logger.debug "Checking if user has moderator rights"
      # Checking up moderator rights. Add it if missing.
      if groups && Rails.application.secrets.sso_moderator_group
        moderatorRegex = '/^' + Rails.application.secrets.sso_moderator_group + '/'
        Rails.logger.debug("Found setting for SSO group " + Rails.application.secrets.sso_moderator_group + ". Checking if group present in SSO attributes")
        if groups.grep(moderatorRegex)
          Rails.logger.debug("Group has been found in SSO attributes. Check moderators right")
          if !Moderator.where(user_id: user.id).exists?
            Rails.logger.debug("User is not moderator. Adding modetators rights.")
            user.moderator = Moderator.new
            user.save!
          end
          flash[:notice] = t('devise.sessions.signed_in')
          sign_in_and_redirect user, event: :authentication
        end
      end
    end

      Rails.logger.debug "Checking if user has administrator rights"
      # Checking up administrator rights. Add it if missing.
      if groups && Rails.application.secrets.sso_administrator_group
        administratorRegex = '/^' + Rails.application.secrets.sso_administrator_group + '/'
        Rails.logger.debug("Found setting for SSO group " + Rails.application.secrets.sso_administrator_group + ". Checking if group present in SSO attributes")
        if groups.grep(administratorRegex)
          Rails.logger.debug("Group has been found in SSO attributes. Check administrator right")
          if !Administrator.where(user_id: user.id).exists?
            Rails.logger.debug("User is not administrator. Adding administrator rights.")
            user.administrator = Administrator.new
            user.save!
          end
          flash[:notice] = t('devise.sessions.signed_in')
          sign_in_and_redirect user, event: :authentication
        end
      end
      Rails.logger.debug "User has neither moderator or administrator rights; redirecting to nemlogin"
      redirect_to nemlogin_url
    end

    flash[:notice] = t('devise.sessions.signed_in')
    sign_in_and_redirect user, event: :authentication
  end

  def nemlogin_url
    uri = URI(Rails.application.secrets.nemlogin_login_uri)
    uri.query = {
      mnemo: Rails.application.secrets.nemlogin_mnemo,
      forward: users_sign_up_success_url
    }.to_query
    uri.to_s
  end
end
