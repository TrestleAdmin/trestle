require "trestle/version"

require "active_support"
require "sass-rails"
require "haml"

module Trestle
  extend ActiveSupport::Autoload
end

require "trestle/engine" if defined?(Rails)
