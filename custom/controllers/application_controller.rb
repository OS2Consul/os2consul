require_dependency Rails.root.join('app', 'controllers', 'application_controller').to_s

class ApplicationController < ActionController::Base

  private

  def set_return_url
    # Use full path as return URL
    if !devise_controller? && controller_name != "welcome" && is_navigational_format?
      store_location_for(:user, request.fullpath)
    end
  end
end
