module Trestle
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Installs Trestle and creates files for configuration and asset customization"

      source_root File.expand_path("../templates", __FILE__)

      def create_initializer
        template "trestle.rb.erb", "config/initializers/trestle.rb"
      end

      def create_assets
        css = (defined?(Sass) || defined?(SassC)) ? "scss" : "css"
        template "_custom.#{css}", "app/assets/stylesheets/trestle/_custom.#{css}"
        template "custom.js", "app/assets/javascripts/trestle/custom.js"
      end

      def create_directory
        empty_directory "app/admin"
      end
    end
  end
end
