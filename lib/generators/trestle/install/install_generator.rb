module Trestle
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Installs Trestle and creates files for configuration and asset customization"

      source_root File.expand_path("../templates", __FILE__)

      def create_initializer
        template "trestle.rb.erb", "config/initializers/trestle.rb"
      end

      def create_assets
        template "_variables.scss", "app/assets/stylesheets/trestle/_variables.scss"
        template "_custom.scss",    "app/assets/stylesheets/trestle/_custom.scss"

        template "custom.js",       "app/assets/javascripts/trestle/custom.js"
      end

      def create_directory
        empty_directory "app/admin"
      end
    end
  end
end
