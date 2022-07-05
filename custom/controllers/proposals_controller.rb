# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'proposals_controller').to_s

class ProposalsController < ApplicationController

  def index_customization
    discard_draft
    discard_archived
    approved_only
    load_retired
    load_selected
    load_featured
    remove_archived_from_order_links
  end

  def new
    if current_user.email.match(/@nemlogin/)
      redirect_to account_path, alert: t("legislation.proposals.flash.email_required")
    end
  end

  def create
    @proposal = Proposal.new(proposal_params.merge(author: current_user))
    if @proposal.save
      redirect_to created_proposal_path(@proposal), notice: I18n.t("flash.actions.create.proposal")
    else
      render :new
    end
  end

  private

    def approved_only
      @resources = @resources.approved
    end

end
