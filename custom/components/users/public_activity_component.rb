# frozen_string_literal: true

require_dependency Rails.root.join('app', 'components', 'users', 'public_activity_component').to_s

class Users::PublicActivityComponent < ApplicationComponent
  private

    def proposals
      Proposal.with_hidden.where(author_id: user.id)
    end
end
