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

    config.to_prepare do
      Engine.reset_helpers!
    end

    config.to_prepare do
      Engine.reloader.execute_if_updated
    end

    def reloader
      @reloader ||= Trestle::Reloader.new
    end

    def reset_helpers!
      @helpers = nil
    end
  end
end
