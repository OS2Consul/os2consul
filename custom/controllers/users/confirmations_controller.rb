# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'users', 'confirmations_controller').to_s

class Users::ConfirmationsController < Devise::ConfirmationsController
  def update
    # Disable user confirmation
    raise NotImplementedError
  end

  def show
    # Disable user confirmation
    raise NotImplementedError
  end

  def new
    # Disable user confirmation
    raise NotImplementedError
  end

  def create
    # Disable user confirmation
    raise NotImplementedError
  end
end
