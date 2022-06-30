# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'proposals_controller').to_s

class ProposalsController < ApplicationController
  def new
    if current_user.email.match(/@nemlogin/)
      redirect_to account_path, alert: t("legislation.proposals.flash.email_required")
    end
  end
end
