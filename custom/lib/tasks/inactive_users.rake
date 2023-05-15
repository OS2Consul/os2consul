namespace :inactive_users do
  desc "Remove users that last signed in before the configured threshold"
  task remove: :environment do
    inactive_users_removal_years = Rails.application.secrets.inactive_users_removal_years.to_i

    if inactive_users_removal_years > 0
      removal_threshold = Time.current - inactive_users_removal_years.years

      puts "Finding users that have not signed in since #{removal_threshold}"

      User.active.where("last_sign_in_at < ?", removal_threshold).each do |user|
        next if user.administrator? || user.moderator? || user.manager? || user.organization? || user.official? || user.poll_officer? || user.sdg_manager?
        puts " - Removing user: #{user.id} [#{user.email}] (last signed in at: #{user.last_sign_in_at})"
        user.erase("Removed due to inactivity for #{inactive_users_removal_years} years")
      end
    end
  end
end
