# frozen_string_literal: true

require_dependency Rails.root.join('app', 'helpers', 'budgets_helper').to_s

module BudgetsHelper
  def budget_currency_symbol_select_options
    Budget::CUSTOM_CURRENCY_SYMBOLS.map { |cs| [cs, cs] }
  end
end
