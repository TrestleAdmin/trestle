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
    end
  end
end
