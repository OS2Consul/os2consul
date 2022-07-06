# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'proposals_controller').to_s

class ProposalsController < ApplicationController
  def new
    if current_user.email.match(/@nemlogin/)
      redirect_to account_path, alert: t("legislation.proposals.flash.email_required")
    end
  end

  def publish
    @proposal.publish
    @proposal.hide
    redirect_to proposals_path, notice: t("proposals.notice.published_and_hidden_for_review")
  end
end
