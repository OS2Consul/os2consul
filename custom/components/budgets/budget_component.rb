class Budgets::BudgetComponent < ApplicationComponent
  delegate :wysiwyg, :auto_link_already_sanitized_html, :render_map, to: :helpers
  attr_reader :budget

  def initialize(budget)
    @budget = budget
  end

  private

    def map_location
      map = MapLocation.new
      map.latitude = budget.map_latitude
      map.longitude = budget.map_longitude
      map.zoom = budget.map_zoom
      map
    end

    def coordinates
      return unless budget.present?

      if budget.publishing_prices_or_later? && budget.investments.selected.any?
        investments = budget.investments.selected
      else
        investments = budget.investments
      end

      MapLocation.where(investment_id: investments).map(&:json_data)
    end
end
