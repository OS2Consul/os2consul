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
    auth = request.env["omniauth.auth"]

    user = User.find_by(email: auth.info.email) || User.new(
      username: auth.uid,
      fullname: auth.info.name,
      email: auth.info.email,
      oauth_email: auth.info.email,
      password: Devise.friendly_token[0, 20],
      confirmed_at: Time.current,
      residence_verified_at: Time.current,
      verified_at: Time.current,
      terms_of_service: '1',
      consent_and_information: '1',
      administrator: Administrator.new
    )

    if user.save
      flash[:notice] = t('devise.sessions.signed_in')
      sign_in_and_redirect user, event: :authentication
    end
  end
end
