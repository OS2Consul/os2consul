# frozen_string_literal: true

require_dependency Rails.root.join('app', 'models', 'user').to_s

class User < ApplicationRecord
  attr_accessor :create_as_administrator
  attr_accessor :consent_and_information
  attr_accessor :registration_state

  validates :consent_and_information, acceptance: { allow_nil: false }, on: :create

  def name
    organization? ? organization.name : (fullname.present? ? fullname : username)
  end

  def password_required?
    false
  end

  def confirmation_required?
    false
  end
end
