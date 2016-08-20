module Trestle
  class Engine < ::Rails::Engine
    isolate_namespace Trestle
    self.routes.default_scope = {}

    # Application assets
    config.assets.precompile << "trestle/admin.css" << "trestle/admin.js"

    # Vendor assets
    config.assets.precompile << %r(trestle/bootstrap-sass/assets/fonts/bootstrap/glyphicons-halflings-regular\.(?:eot|svg|ttf|woff|woff2)$)
    config.assets.precompile << %r(trestle/font-awesome/fonts/fontawesome-webfont\.(?:eot|svg|ttf|woff|woff2)$)

    # Optional turbolinks
    config.assets.precompile << "turbolinks.js" if defined?(Turbolinks)

    initializer "trestle.automount" do |app|
      if Trestle.config.automount
        app.routes.prepend do
          mount Trestle::Engine => Trestle.config.path
        end
      end
    end

    initializer "trestle.reload" do |app|
      reloader = self.reloader
      reloader.execute

      ActiveSupport::Reloader.to_prepare do
        # Force-reload files underneath app/admin folders so that their routes can be loaded
        reloader.execute_if_updated
      end
    end

    initializer "trestle.reset_helpers" do |app|
      engine = self

      ActiveSupport::Reloader.to_prepare do
        engine.reset_helpers!
      end
    end

    def reloader
      @reloader ||= Trestle::Reloader.new
    end

    def reset_helpers!
      @helpers = nil
    end
  end
end
