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

    initializer "trestle.theme" do |app|
      # Enable theme compilation
      if Trestle.config.theme
        app.config.assets.paths << root.join("frontend/theme").to_s
        app.config.assets.precompile << "trestle/theme.css"
      end
    end

    initializer "trestle.turbolinks" do |app|
      # Optional turbolinks
      app.config.assets.precompile << "turbolinks.js" if Trestle.config.turbolinks
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
