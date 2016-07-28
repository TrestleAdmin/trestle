require "trestle/version"

require "active_support"
require "haml"

module Trestle
  extend ActiveSupport::Autoload
end

require "trestle/engine" if defined?(Rails)
