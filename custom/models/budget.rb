# frozen_string_literal: true

require_dependency Rails.root.join('app', 'models', 'budget').to_s

class Budget < ApplicationRecord
  CUSTOM_CURRENCY_SYMBOLS = %w[DKK € $ £ ¥].freeze

  def map_latitude
    return Setting["map.latitude"] if self[:map_latitude].nil?
    self[:map_latitude]
  end

  def map_longitude
    return Setting["map.longitude"] if self[:map_longitude].nil?
    self[:map_longitude]
  end

  def map_zoom
    return Setting["map.zoom"] if self[:map_zoom].nil?
    self[:map_zoom]
  end
end
