require "sprockets/railtie"

module Trestle
  class Engine < ::Rails::Engine
    isolate_namespace Trestle
    self.routes.default_scope = {}

    # Application assets
    config.assets.precompile << "trestle/admin.css" << "trestle/admin.js" << "trestle/custom.css"

    # Vendor assets
    %w(eot svg ttf woff woff2).each do |ext|
      config.assets.precompile << "trestle/fa-*.#{ext}"
    end

    initializer "trestle.automount" do |app|
      if Trestle.config.automount
        app.routes.prepend do
          mount Trestle::Engine => Trestle.config.path
        end
      end
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
