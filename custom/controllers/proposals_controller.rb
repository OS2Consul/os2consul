# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'proposals_controller').to_s

class ProposalsController < ApplicationController
  prepend_before_action :load_proposal, only: [:show, :edit, :update]

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

  private

  def load_proposal
    @proposal = Proposal.with_hidden.find(params[:id])
  end

  def discard_archived
    unless @current_order == "archival_date" || params[:selected].present?
      @resources = @resources.not_archived
    end

    @resources = @resources.where("ignored_flag_at IS NULL OR ignored_flag_at > ?", Setting["months_to_archive_proposals"].to_i.months.ago)
  end
end
