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
  autoload :Display
  autoload :Form
  autoload :ModelName
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

  def self.lookup(admin)
    return admin if admin.is_a?(Class) && admin < Trestle::Admin
    self.admins[admin.to_s]
  end

  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure(&block)
    config.configure(&block)
  end

  def self.navigation
    Navigation.new(config.menus + admins.values.map(&:menu).compact)
  end
end

require "trestle/engine" if defined?(Rails)
