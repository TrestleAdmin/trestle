module Trestle
  class Resource < Admin
    extend ActiveSupport::Autoload

    autoload :Builder
    autoload :Controller

    class << self
      attr_writer :collection
      attr_writer :instance
      attr_writer :paginate
      attr_writer :decorator

      def collection
        if @collection
          @collection.call
        else
          model.all
        end
      end

      def instance(params)
        if @instance
          @instance.call(params)
        else
          collection.find(params[:id])
        end
      end

      def paginate(collection, params)
        if @paginate
          @paginate.call(collection, params)
        else
          collection = Kaminari.paginate_array(collection) unless collection.respond_to?(:page)
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

      def sort(collection, params)
        if params[:sort]
          collection.reorder(params[:sort] => params[:order] || "asc")
        else
          collection
        end
      end

      def model
        @model ||= options[:model] || infer_model_class
      end

      def model_name
        options[:as] || model.model_name.to_s.titleize
      end

      def breadcrumb
        Breadcrumb.new(model_name.pluralize, path)
      end

      def routes
        admin = self

        Proc.new do
          resources admin.admin_name, controller: admin.controller_namespace, as: admin.route_name, path: admin.options[:path]
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
