# frozen_string_literal: true

require_dependency Rails.root.join('app', 'models', 'budget').to_s

class Budget < ApplicationRecord
  CUSTOM_CURRENCY_SYMBOLS = %w[DKK € $ £ ¥].freeze
end
