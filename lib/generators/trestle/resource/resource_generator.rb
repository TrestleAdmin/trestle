module Trestle
  module Generators
    class ResourceGenerator < ::Rails::Generators::NamedBase
      desc "Creates a Trestle admin resource"

      class_option :singular, type: :boolean, default: false, desc: "Generate a singular resource"

      source_root File.expand_path("../templates", __FILE__)

      def create_admin
        template "admin.rb.erb", File.join("app/admin", class_path, "#{admin_name}_admin.rb")
      end

      def admin_name
        singular? ? singular_name : plural_name
      end

      def parameter_name
        singular_name.singularize
      end

      def singular?
        options[:singular]
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
