# frozen_string_literal: true

require_dependency Rails.root.join('app', 'models', 'i18n_content').to_s

class I18nContent < ApplicationRecord
  def self.devise_views_user
    %w[
      devise_views.users.registrations.success.condition_checkbox.label.text
      devise_views.users.registrations.success.condition_checkbox.label.link_text
      devise_views.users.registrations.success.condition_checkbox.undertext
      devise_views.users.registrations.success.consent_checkbox.label.text
      devise_views.users.registrations.success.consent_checkbox.undertext
      devise_views.users.registrations.success.consent_checkbox.undertext_link_text
      devise_views.users.registrations.success.footer_text
    ]
  end

  def self.translations_for(tab)
    if tab.to_s == "basic"
      basic_translations
    elsif tab.to_s == "machine_learning"
      machine_learning_translations
    elsif tab.to_s == "devise_views_user"
      devise_views_user
    else
      flat_hash(translations_hash_for(tab)).keys
    end
  end

end
