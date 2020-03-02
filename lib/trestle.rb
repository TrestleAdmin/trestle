require_relative "trestle/version"

require "active_support/all"
require "kaminari"

module Trestle
  require_relative "trestle/evaluation_context"
  require_relative "trestle/builder"
  require_relative "trestle/hook"
  require_relative "trestle/toolbar"
  require_relative "trestle/adapters"
  require_relative "trestle/attribute"
  require_relative "trestle/breadcrumb"
  require_relative "trestle/configurable"
  require_relative "trestle/configuration"
  require_relative "trestle/display"
  require_relative "trestle/form"
  require_relative "trestle/model_name"
  require_relative "trestle/navigation"
  require_relative "trestle/options"
  require_relative "trestle/reloader"
  require_relative "trestle/scopes"
  require_relative "trestle/tab"
  require_relative "trestle/table"
  require_relative "trestle/admin"
  require_relative "trestle/resource"

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

  def self.navigation(context)
    blocks = config.menus + admins.values.map(&:menu).compact
    Navigation.build(blocks, context)
  end

  def self.i18n_fallbacks(locale=I18n.locale)
    if I18n.respond_to?(:fallbacks)
      I18n.fallbacks[locale]
    elsif locale.to_s.include?("-")
      fallback = locale.to_s.split("-").first
      [locale, fallback]
    else
      [locale]
    end
  end
end

require_relative "trestle/engine" if defined?(Rails)
