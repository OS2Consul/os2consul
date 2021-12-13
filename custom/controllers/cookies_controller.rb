class CookiesController < ApplicationController
  skip_authorization_check

  def consent
    cookies[:consent_given] = Time.current.to_s
    redirect_to root_path
  end
end
