require "trestle/version"

require "active_support/all"

require "sass-rails"
require "autoprefixer-rails"
require "kaminari"

module Trestle
  extend ActiveSupport::Autoload

  autoload :Adapters
  autoload :Admin
  autoload :Attribute
  autoload :Breadcrumb
  autoload :Builder
  autoload :Configurable
  autoload :Configuration
  autoload :Form
  autoload :Navigation
  autoload :Options
  autoload :Reloader
  autoload :Resource
  autoload :Scope
  autoload :Tab
  autoload :Table

  mattr_accessor :admins
  self.admins = {}

  def self.admin(name, options={}, &block)
    admin = Admin::Builder.build(name, options, &block)
    self.admins[admin.admin_name] = admin
  end

  def self.resource(name, options={}, &block)
    admin = Resource::Builder.build(name, options, &block)
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
