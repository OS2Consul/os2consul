require_dependency Rails.root.join('app', 'controllers', 'management', 'proposals_controller').to_s

class Management::ProposalsController < Management::BaseController
  skip_before_action :only_verified_users, only: [:export, :export_one]

  has_orders %w[confidence_score hot_score created_at most_commented random], only: [:index]
  has_orders %w[confidence_score hot_score created_at most_commented random hidden], only: [:print]

  def export
    if params[:order] == "hidden"
      @proposals = Proposal.only_hidden.send("sort_by_created_at").for_render
    else
      @proposals = Proposal.send("sort_by_#{params[:order] || "created_at"}").for_render
    end

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

  def export_one
    @proposal = Proposal.with_hidden.find(params[:id])

    respond_to do |format|
      format.pdf do
        render pdf: "export_one",
           page_size: "A4",
           orientation: "Portrait",
           dpi: 300,
           zoom: 0.5,
           show_as_html: Rails.env.test? || params.key?("debug")
      end
    end
  end

  def print
    if @current_order == "hidden"
      @proposals = Proposal.only_hidden.send("sort_by_created_at").for_render
    else
      @proposals = Proposal.send("sort_by_#{@current_order}").for_render
    end
    set_proposal_votes(@proposal)
  end
end
