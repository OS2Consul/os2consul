# frozen_string_literal: true

require_dependency Rails.root.join('app', 'models', 'user').to_s

class User < ApplicationRecord
  def name
    organization? ? organization.name : (fullname.present? ? fullname : username)
  end

  def password_required?
    false
  end

  def confirmation_required?
    false
  end

  class_eval do
    _validators.delete(:terms_of_service)

    _validate_callbacks.each do |callback|
      if callback.raw_filter.respond_to? :attributes
        callback.raw_filter.attributes.delete :terms_of_service
      end
    end
  end
end
