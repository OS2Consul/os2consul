# frozen_string_literal: true

require_dependency Rails.root.join('app', 'helpers', 'management_helper').to_s

module ManagementHelper
  def menu_users?
    !menu_new_user? && %w[users email_verifications document_verifications].include?(controller_name)
  end

  def menu_new_user?
    controller_name == 'users' && action_name == 'new'
  end
end
