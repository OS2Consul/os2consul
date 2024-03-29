require_dependency Rails.root.join('app', 'models', 'proposal').to_s

class Proposal < ApplicationRecord
  scope :published,                -> { where("proposals.ignored_flag_at IS NULL OR proposals.ignored_flag_at > ?", Setting["months_to_archive_proposals"].to_i.months.ago).where.not(published_at: nil) }

  def editable_by?(user)
    (author_id == user.id || user.administrator?) && editable?
  end

  def archived?
    if ignored_flag_at.present?
      ignored_flag_at <= Setting["months_to_archive_proposals"].to_i.months.ago
    elsif published_at.present?
      published_at <= Setting["months_to_archive_proposals"].to_i.months.ago
    else
      created_at <= Setting["months_to_archive_proposals"].to_i.months.ago
    end
  end
end
