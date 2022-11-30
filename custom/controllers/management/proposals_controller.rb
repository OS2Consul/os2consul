require_dependency Rails.root.join('app', 'controllers', 'management', 'proposals_controller').to_s

class Management::ProposalsController < Management::BaseController
  skip_before_action :only_verified_users, only: :export

  def export
    @proposals = Proposal.send("sort_by_confidence_score").for_render

    respond_to do |format|
      format.pdf do
        render pdf: "export",
           page_size: "A4",
           orientation: "Landscape",
           dpi: 300,
           zoom: 0.5,
           show_as_html: Rails.env.test? || params.key?("debug")
      end
    end
  end
end
