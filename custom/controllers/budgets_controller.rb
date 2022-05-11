# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'budgets_controller').to_s

class BudgetsController < ApplicationController
  def index
    @finished_budgets = @budgets.finished.order(created_at: :desc)
    @budgets = Budget.published.order(created_at: :desc).page(params[:page])
  end
end