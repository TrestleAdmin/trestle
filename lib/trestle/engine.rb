module Trestle
  class Engine < ::Rails::Engine
    isolate_namespace Trestle
    self.routes.default_scope = {}

    # Application assets
    config.assets.precompile << "trestle/admin.css" << "trestle/admin.js"

    # Vendor assets
    %w(eot svg ttf woff woff2).each do |ext|
      config.assets.precompile << "trestle/bootstrap-sass/assets/fonts/bootstrap/glyphicons-halflings-regular.#{ext}"
      config.assets.precompile << "trestle/font-awesome/fonts/fontawesome-webfont.#{ext}"
      config.assets.precompile << "trestle/ionicons/fonts/ionicons.#{ext}"
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

    initializer "trestle.turbolinks" do |app|
      # Optional turbolinks
      app.config.assets.precompile << "turbolinks.js" if Trestle.config.turbolinks
    end

    config.to_prepare do
      Engine.reset_helpers!
    end

    config.to_prepare do
      if Trestle.config.reload == :always
        Engine.reloader.execute
      else
        Engine.reloader.execute_if_updated
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
