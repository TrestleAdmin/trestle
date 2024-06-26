require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "trestle"

module Sandbox
  class Application < Rails::Application
    # Initialize configuration defaults for current Rails version.
    config.load_defaults Rails::VERSION::STRING.to_f

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.action_view.form_with_generates_ids = true
  end
end
