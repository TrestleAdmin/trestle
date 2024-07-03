# frozen_string_literal: true

require "bundler/setup"
require "rails"
require "active_support/railtie"
require "action_view/railtie"

I18n.load_path += Dir["./config/locales/**/*.yml"]