require_relative "trestle/version"

require "active_support/all"
require "kaminari"

module Trestle
  require_relative "trestle/evaluation_context"
  require_relative "trestle/builder"
  require_relative "trestle/color"
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
  def self.resource(name, **options, &block)
    register(Resource::Builder.create(name, options, &block))
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

  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new('1.0', 'Trestle')
  end
end

require_relative "trestle/engine" if defined?(Rails)
