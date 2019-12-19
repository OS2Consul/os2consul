require_dependency Rails.root.join('app', 'helpers', 'application_helper').to_s

module ApplicationHelper
  def strip_checkbox_errors(&block)
    capture(&block).gsub(%r{<small .*</small>}, '').html_safe
  end
end
