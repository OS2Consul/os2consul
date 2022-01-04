class CookiesController < ApplicationController
  skip_authorization_check

  def consent
    # Prevent infinite redirects
    if cookies[:consent_given]
      redirect_to root_path
      return
    end
    cookies[:consent_given] = Time.current.to_s
    redirect_back(fallback_location: root_path)
  end
end
