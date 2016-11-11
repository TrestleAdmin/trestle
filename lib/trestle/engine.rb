module Trestle
  class Engine < ::Rails::Engine
    isolate_namespace Trestle
    self.routes.default_scope = {}

    # Application assets
    config.assets.precompile << "trestle/admin.css" << "trestle/admin.js"

    # Vendor assets
    config.assets.precompile << %r(trestle/bootstrap-sass/assets/fonts/bootstrap/glyphicons-halflings-regular\.(?:eot|svg|ttf|woff|woff2)$)
    config.assets.precompile << %r(trestle/font-awesome/fonts/fontawesome-webfont\.(?:eot|svg|ttf|woff|woff2)$)
    config.assets.precompile << %r(trestle/ionicons/fonts/ionicons\.(?:eot|svg|ttf|woff)$)

    # Optional turbolinks
    config.assets.precompile << "turbolinks.js" if Trestle.config.turbolinks

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
