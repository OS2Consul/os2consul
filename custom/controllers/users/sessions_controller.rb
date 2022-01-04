# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'users', 'sessions_controller').to_s

class Users::SessionsController < Devise::SessionsController
  alias new_without_nemlogin new
  alias create_without_nemlogin create

  def new
    if Rails.application.secrets.saml_ip_ranges.split(',').map(&:strip).any? { |ip_range| IPAddr.new(ip_range).include? request.remote_ip }
      redirect_to user_saml_omniauth_authorize_path
    else
      # Use nemlogin for authentication, unless for administrators
      if authenticated_return_url.start_with? '/admin'
        session[:nemlogin_is_admin] = true
        new_without_nemlogin
      else
        redirect_to nemlogin_url
      end
    end
  end

  def create
    # Only administrators are allowed to sign in without nemlogin
    return create_without_nemlogin if session[:nemlogin_is_admin]

    raise NotImplementedError
  end

  private

  def authenticated_return_url
    session[stored_location_key_for(:user)] || root_path
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
