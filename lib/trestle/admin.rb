module Trestle
  class Admin
    class << self
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
            get admin.admin_name, action: "index", as: admin.route_name
          end
        end
      end
    end
  end
end
