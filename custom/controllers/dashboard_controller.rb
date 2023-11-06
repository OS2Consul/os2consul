# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'dashboard_controller').to_s

class DashboardController < Dashboard::BaseController
  def publish
    authorize! :publish, proposal

    proposal.publish
    @proposal.hide
    redirect_to proposals_path, notice: t("proposals.notice.published_and_hidden_for_review")
  end

  private
  
  def proposal
    @proposal ||= Proposal.with_hidden.includes(:community).find(params[:proposal_id])
  end
end
