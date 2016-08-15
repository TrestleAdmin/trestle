require "trestle/version"

require "active_support/all"

require "haml"
require "sass-rails"
require "autoprefixer-rails"

module Trestle
  extend ActiveSupport::Autoload

  autoload :Admin
  autoload :Configurable
  autoload :Configuration
  autoload :Navigation

  mattr_accessor :admins
  self.admins = {}

  def self.navigation
    Navigation.new(config.menus)
  end

  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure
    yield config
  end
end

require "trestle/engine" if defined?(Rails)
