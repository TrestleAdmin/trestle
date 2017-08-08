module Trestle
  module Generators
    class ResourceGenerator < ::Rails::Generators::NamedBase
      desc "Creates a Trestle admin resource"

      source_root File.expand_path("../templates", __FILE__)

      def create_admin
        template "admin.rb.erb", File.join("app/admin", class_path, "#{plural_name}_admin.rb")
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
