# frozen_string_literal: true

require_dependency Rails.root.join('app', 'models', 'proposal').to_s

class Proposal < ApplicationRecord

  scope :approved,                 -> { where(approved: true) }
  scope :not_approved,             -> { where(approved: false) }

end
