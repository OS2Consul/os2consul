# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'dashboard_controller').to_s

class DashboardController < Dashboard::BaseController

  def publish
    authorize! :publish, proposal

    if (proposal.approved?)
      proposal.publish
      redirect_to progress_proposal_dashboard_path(proposal), notice: t("proposals.notice.published")
    else
      redirect_to proposal_dashboard_path(proposal), notice: t("proposals.notice.need_to_be_approved_first")
    end
  end

end
