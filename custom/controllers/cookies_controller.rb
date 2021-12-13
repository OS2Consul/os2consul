class CookiesController < ApplicationController
  skip_authorization_check

  def consent
    cookies[:consent_given] = Time.current.to_s
    redirect_back(fallback_location: root_path)
  end
end
