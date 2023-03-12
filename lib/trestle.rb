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
  require_relative "trestle/debug_errors"
  require_relative "trestle/lazy"
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
  require_relative "trestle/registry"
  require_relative "trestle/resource"

  # The registry records all active Trestle admins and facilitates lookups.
  mattr_accessor :registry
  self.registry = Registry.new

  class << self
    # Expose registry methods on Trestle module
    delegate :register, :lookup, :lookup_model, :admins, to: :registry
  end

  # Builds and registers a new plain admin
  def self.admin(name, **options, &block)
    register(Admin::Builder.create(name, options, &block))
  end

  # Builds and registers a new admin resource
  def self.resource(name, register_model: true, **options, &block)
    register(Resource::Builder.create(name, options, &block), register_model: register_model)
  end

  # Configuration methods

  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure(&block)
    config.configure(&block)
  end

  # Builds the global navigation by combining the menu options from the
  # Trestle configuration along with menu blocks from admin resources.
  def self.navigation(context)
    blocks = config.menus + registry.map(&:menu).compact
    Navigation.build(blocks, context)
  end

  # Returns the I18n fallbacks for the given locale.
  #
  # This is used from within a Sprockets asset (JavaScript)
  # to determine which locale files to include.
  #
  # Examples
  #
  #   Trestle.i18n_fallbacks("pt-BR") => ["pt-BR", "pt"]
  #   Trestle.i18n_fallbacks("ca") => ["ca", "es-ES", "es"] %>
  #
  # Returns an array of locale Strings.
  def self.i18n_fallbacks(locale=I18n.locale)
    if I18n.respond_to?(:fallbacks)
      I18n.fallbacks[locale].map(&:to_s)
    elsif locale.to_s.include?("-")
      fallback = locale.to_s.split("-").first
      [locale, fallback]
    else
      [locale]
    end
  end
end

require_relative "trestle/engine" if defined?(Rails)
