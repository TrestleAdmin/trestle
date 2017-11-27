module Trestle
  class Admin
    extend ActiveSupport::Autoload

    autoload :Builder
    autoload :Controller

    class << self
      attr_accessor :menu

      attr_accessor :table
      attr_accessor :form

      attr_accessor :additional_routes

      attr_writer :options
      attr_writer :breadcrumb

      def options
        @options ||= {}
      end

      def breadcrumbs
        Breadcrumb::Trail.new(Array(Trestle.config.root_breadcrumbs) + [breadcrumb])
      end

      def breadcrumb
        if @breadcrumb
          Breadcrumb.cast(@breadcrumb.call)
        else
          default_breadcrumb
        end
      end

      def default_breadcrumb
        Breadcrumb.new(I18n.t("admin.breadcrumbs.#{admin_name}", default: admin_name.titleize), path)
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

      def actions
        [:index]
      end

      def routes
        admin = self

        Proc.new do
          scope controller: admin.controller_namespace, path: admin.options[:path] || admin.admin_name do
            get "", action: "index", as: admin.route_name

            instance_exec(&admin.additional_routes) if admin.additional_routes
          end
        end
      end

      def railtie_routes_url_helpers(include_path_helpers=true)
        Trestle.railtie_routes_url_helpers(include_path_helpers)
      end
    end
  end
end
