require_dependency Rails.root.join('app', 'models', 'proposal').to_s

class Proposal < ApplicationRecord
  def editable_by?(user)
    (author_id == user.id || user.administrator?) && editable?
  end
end
