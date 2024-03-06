# frozen_string_literal: true

require_dependency Rails.root.join('app', 'controllers', 'admin', 'stats_controller').to_s

class Admin::StatsController < Admin::BaseController
  def budget_balloting
    @budget = Budget.find(params[:budget_id])

    authorize! :read_admin_stats, @budget, message: t("admin.stats.budgets.no_data_before_balloting_phase")

    @user_count = @budget.ballots.select { |ballot| ballot.lines.any? }.count

    @vote_count = @budget.lines.count

    @vote_count_by_heading = @budget.lines.group(:heading_id).count.map { |k, v| [Budget::Heading.find_by(id: k).try(:name) || "", v] }.sort

    @user_count_by_district = User.where.not(balloted_heading_id: nil).group(:balloted_heading_id).count.map { |k, v| [Budget::Heading.find_by(id: k).try(:name) || "", v] }.sort
  end
end
