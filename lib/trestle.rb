require "trestle/version"

require "active_support/all"

require "haml"
require "sass-rails"
require "autoprefixer-rails"

module Trestle
  extend ActiveSupport::Autoload

  autoload :Configurable
  autoload :Configuration

  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure
    yield config
  end
end

require "trestle/engine" if defined?(Rails)
