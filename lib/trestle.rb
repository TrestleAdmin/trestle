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
  autoload :Hook
  autoload :ModelName
  autoload :Navigation
  autoload :Options
  autoload :Reloader
  autoload :Resource
  autoload :Scope
  autoload :Tab
  autoload :Table
  autoload :Toolbar

  mattr_accessor :admins
  self.admins = {}

  def self.admin(name, options={}, &block)
    register(Admin::Builder.create(name, options, &block))
  end

  def self.resource(name, options={}, &block)
    register(Resource::Builder.create(name, options, &block))
  end

  def self.register(admin)
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
    Navigation.build(config.menus + admins.values.map(&:menu).compact)
  end
end

require "trestle/engine" if defined?(Rails)
