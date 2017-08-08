module Trestle
  module Generators
    class AdminGenerator < ::Rails::Generators::NamedBase
      desc "Creates a non-resourceful Trestle admin"

      source_root File.expand_path("../templates", __FILE__)

      def create_admin
        template "admin.rb.erb", File.join("app/admin", class_path, "#{singular_name}_admin.rb")
      end

      def create_template
        template "index.html.erb", File.join("app/views/admin", class_path, singular_name, "index.html.erb")
      end

    protected
      def module_name
        class_name.deconstantize
      end

      def module?
        module_name.present?
      end
    end
  end
end
