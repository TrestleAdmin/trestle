require_relative 'boot'

require 'rails/all'
require 'sprockets/railtie'
require 'turbolinks'

Bundler.require(*Rails.groups)
require "trestle"

module Sandbox
  class Application < Rails::Application
    # Initialize configuration defaults for current Rails version.
    case Rails.version.split(".").first(2).join(".")
    when '7.1'
      config.load_defaults 7.1
    when '7.0'
      config.load_defaults 7.0
    when '6.0'
      config.load_defaults 6.0
    when '5.2'
      config.load_defaults 5.2
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.action_view.form_with_generates_ids = true
  end
end
