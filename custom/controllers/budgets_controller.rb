# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'budgets_controller').to_s

class BudgetsController < ApplicationController
  def index
    @finished_budgets = @budgets.finished.order(created_at: :desc)
    @current_filter ||= "open"
    @budgets = Budget.send(@current_filter).published.order(created_at: :desc).page(params[:page])
  end
end