module Trestle
  class Resource < Admin
    extend ActiveSupport::Autoload

    autoload :Builder
    autoload :Controller

    class << self
      attr_writer :collection
      attr_writer :paginate
      attr_writer :decorator

      def collection
        if @collection
          @collection.call
        else
          model.all
        end
      end

      def paginate(collection, params)
        if @paginate
          @paginate.call(collection, params)
        else
          collection.page(params[:page])
        end
      end

      def decorate(collection)
        if @decorator
          @decorator.decorate_collection(collection)
        else
          collection
        end
      end

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
