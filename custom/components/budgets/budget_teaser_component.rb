class Budgets::BudgetTeaserComponent < ApplicationComponent
    delegate :wysiwyg, :auto_link_already_sanitized_html, to: :helpers
    attr_reader :budget

    def initialize(budget)
      @budget = budget
    end

    def start_date(budget)
        time_tag(budget.current_phase.starts_at.to_date, format: :long) if budget.current_phase.starts_at.present?
    end
  
    def end_date(budget)
        time_tag(budget.current_phase.ends_at.to_date - 1.day, format: :long) if budget.current_phase.ends_at.present?
    end
end
  