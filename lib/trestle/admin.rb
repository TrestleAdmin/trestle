module Trestle
  class Admin
    extend ActiveSupport::Autoload

    autoload :Builder
    autoload :Controller

    class << self
      attr_accessor :menu

      attr_accessor :table
      attr_accessor :form

      attr_writer :options

      def options
        @options ||= {}
      end

      def breadcrumbs
        @breadcrumbs ||= Trestle::Breadcrumb::Trail.new([
          Trestle.config.root_breadcrumb,
          breadcrumb
        ])
      end

      def breadcrumb
        Breadcrumb.new(admin_name.titleize.pluralize, path)
      end

      def admin_name
        name.underscore.sub(/_admin$/, '')
      end

      def route_name
        "#{admin_name.tr('/', '_')}_admin"
      end

      def controller_path
        "admin/#{name.underscore.sub(/_admin$/, '')}"
      end

      def controller_namespace
        "#{name.underscore}/admin"
      end

      def path(action=:index, options={})
        Engine.routes.url_for(options.merge(controller: controller_namespace, action: action, only_path: true))
      end

      def routes
        admin = self

        Proc.new do
          controller admin.controller_namespace do
            get admin.options[:path] || admin.admin_name, action: "index", as: admin.route_name
          end
        end
      end

      def railtie_routes_url_helpers(include_path_helpers=true)
        Trestle.railtie_routes_url_helpers(include_path_helpers)
      end
    end
  end
end
