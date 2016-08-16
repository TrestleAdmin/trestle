require "trestle/version"

require "active_support/all"

require "haml"
require "sass-rails"
require "autoprefixer-rails"

module Trestle
  extend ActiveSupport::Autoload

  autoload :Admin
  autoload :AdminBuilder
  autoload :AdminController
  autoload :Builder
  autoload :Configurable
  autoload :Configuration
  autoload :Navigation
  autoload :Reloader

  mattr_accessor :admins
  self.admins = {}

  def self.admin(name, options={}, &block)
    admin = AdminBuilder.build(name, options, &block)
    self.admins[admin.admin_name] = admin
  end

  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure
    yield config
  end

  def self.navigation
    Navigation.new(config.menus + admins.values.map(&:menu).compact)
  end
end

require "trestle/engine" if defined?(Rails)
