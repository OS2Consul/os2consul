# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'admin', 'hidden_proposals_controller').to_s

class Admin::HiddenProposalsController < Admin::BaseController
  alias original_index index
  def index
    original_index
    @draft_proposals = Proposal.draft.sort_by_created_at
  end

  alias original_restore restore
  def restore
    if @proposal.draft?
      @proposal.publish
    end
    original_restore
  end
end
