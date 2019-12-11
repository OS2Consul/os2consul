# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'management', 'users_controller').to_s

class Management::UsersController < Management::BaseController
  alias original_new new
  def new
    return original_new if params.key?(:user)

    @user = User.new
    render 'new_alternative'
  end

  alias original_create create
  def create
    return original_create unless params.key?(:alternative)

    @user = User.new(alternative_user_params)

    if @user.email.blank?
      user_without_email
    else
      user_with_email
    end

    @user.terms_of_service = '1'
    @user.residence_verified_at = Time.current
    @user.verified_at = Time.current

    @user.administrator = Administrator.new if @user.create_as_administrator == "1"

    if @user.save
      render :show
    else
      render 'new_alternative'
    end
  end

  private

  def alternative_user_params
    params.require(:user).permit(:username, :email, :password, :create_as_administrator)
  end
end
