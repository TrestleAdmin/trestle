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
          mount Trestle::Engine => Trestle.config.path
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

    initializer "turbo.mimetype" do
      Mime::Type.register "text/vnd.turbo-stream.html", :turbo_stream unless Mime[:turbo_stream]
    end

    initializer "turbo.renderer" do
      ActiveSupport.on_load(:action_controller) do
        # Compatibility fix for Rails 5.2
        delegate :media_type, to: "@_response" unless instance_methods.include?(:media_type)

        ActionController::Renderers.add :turbo_stream do |turbo_streams_html, options|
          self.content_type = Mime[:turbo_stream] if media_type.nil?
          turbo_streams_html
        end
      end
    end

    config.to_prepare do
      Engine.reset_helpers!
    end

    config.after_initialize do |app|
      reloader = Trestle::Reloader.new(*app.watchable_args)
      reloader.install(app) unless app.config.eager_load
    end

    def reset_helpers!
      @helpers = nil
    end
  end
end
