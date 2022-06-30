# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'account_controller').to_s

class AccountController < ApplicationController
  alias original_update update
  def update
    @account.skip_reconfirmation!
    return original_update
  end

  def show
    # Replace default value for email if user has email from nemlogin.
    @account_email = if @account.email.match(/@nemlogin/)
                       ''
                     else
                       @account.email
                     end
  end

  private

  def account_params
    # Don't allow users to change their username
    attributes = if @account.organization?
                   [:phone_number, :email_on_comment, :email_on_comment_reply, :newsletter,
                    organization_attributes: %i[name responsible_name]]
                 else
                   %i[email public_activity public_interests email_on_comment
                      email_on_comment_reply email_on_direct_message email_digest newsletter
                      official_position_badge recommended_debates recommended_proposals]
                 end
    params.require(:account).permit(*attributes)
  end
end
