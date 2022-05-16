# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'users', 'omniauth_callbacks_controller').to_s

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
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

  def failure
    # Disable third-party authentication
    raise NotImplementedError
  end

  def passthru
    # Disable third-party authentication
    raise NotImplementedError
  end

  def after_sign_in_path_for
    # Disable third-party authentication
    raise NotImplementedError
  end
end
