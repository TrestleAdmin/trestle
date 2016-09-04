module Trestle
  class Resource < Admin
    extend ActiveSupport::Autoload

    autoload :Builder
    autoload :Controller

    class << self
      attr_accessor :collection

      def model
        options[:model] || infer_model_class
      end

      def routes
        admin = self

        Proc.new do
          resources admin.admin_name, controller: admin.controller_namespace, as: admin.route_name
        end
      end

    private
      def infer_model_class
        parent.const_get(admin_name.classify)
      rescue NameError
        nil
      end
    end
  end
end
