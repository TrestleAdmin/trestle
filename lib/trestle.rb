require "trestle/version"

require "active_support"
require "haml"
require "sass-rails"
require "autoprefixer-rails"

module Trestle
  extend ActiveSupport::Autoload
end

require "trestle/engine" if defined?(Rails)
