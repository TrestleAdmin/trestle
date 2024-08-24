require "turbo-rails"

module Trestle
  class Engine < ::Rails::Engine
    isolate_namespace Trestle
    self.routes.default_scope = {}

    initializer "trestle.sprockets" do |app|
      # Sprockets manifest
      config.assets.precompile << "trestle/manifest.js"
    end if defined?(Sprockets)

    initializer "trestle.propshaft" do |app|
      app.config.assets.excluded_paths << Trestle::Engine.root.join("app/assets/sprockets")
    end if defined?(Propshaft)

    initializer "trestle.automount" do |app|
      if Trestle.config.automount
        app.routes.prepend do
          mount Trestle::Engine, at: Trestle.config.path
        end
      end
    end

    initializer "trestle.deprecator" do |app|
      app.deprecators[:trestle] = Trestle.deprecator if app.respond_to?(:deprecators)
    end

    initializer "trestle.draper" do |app|
      if defined?(Draper)
        Draper::CollectionDecorator.delegate :current_page, :total_pages, :limit_value, :entry_name, :total_count, :offset_value, :last_page?
      end
    end

    config.to_prepare do
      Engine.reset_helpers!
    end

    config.after_initialize do |app|
      reloader = Trestle::Reloader.new(*app.watchable_args)
      reloader.install(app) unless app.config.eager_load
    end

    # For compatibility with the `sassc-rails`` gem, register a custom compressor that excludes the
    # Trestle admin stylesheets as a) they are already minimized and b) libsass is not compatible with
    # some of the newer CSS syntax that is used.
    #
    # To avoid this being necessary, it is recommended that either
    #   1) `sassc-rails` is removed from the Gemfile (if not required),
    #   2) the `sassc-embedded` gem is added to the Gemfile, or
    #   3) `sassc-rails` is replaced with `dartsass-sprockets`
    config.assets.configure do |env|
      if original_compressor = config.assets.css_compressor
        require "trestle/sprockets_compressor"
        original_compressor = Sprockets.compressors['text/css'][original_compressor] if original_compressor.is_a?(Symbol)
        config.assets.css_compressor = Trestle::SprocketsCompressor.new(original_compressor)
      end
    end if defined?(SassC::Rails)

    def reset_helpers!
      @helpers = nil
    end
  end
end
