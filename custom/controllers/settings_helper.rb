# frozen_string_literal: true

require_dependency Rails.root.join('app', 'helpers', 'settings_helper').to_s

module SettingsHelper
  alias original_feature? feature?

  def feature?(_name)
    if _name.to_s.end_with? '_login'
      # Always disable third-party authentication (Twitter, Facebook etc.)
      false
    else
      original_feature?(_name)
    end
  end
end
