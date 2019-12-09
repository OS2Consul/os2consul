# frozen_string_literal: true

module Consul
  class Application < Rails::Application
    # Default to Danish locale
    config.i18n.default_locale = :da
  end
end
