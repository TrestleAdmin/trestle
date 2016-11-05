module Trestle
  class Resource < Admin
    extend ActiveSupport::Autoload

    autoload :Builder
    autoload :Controller

    class << self
      def adapter
        @adapter ||= Trestle.config.default_adapter.new(self)
      end

      def adapter=(klass)
        @adapter = klass.new(self)
      end

      # Defines a method that can be overridden with a custom block,
      # but is otherwise delegated to the adapter instance.
      def self.adapter_method(name)
        attr_writer name

        define_method(name) do |*args|
          if override = instance_variable_get("@#{name}")
            override.call(*args)
          else
            adapter.public_send(name, *args)
          end
        end
      end

      adapter_method :collection
      adapter_method :find_instance
      adapter_method :build_instance
      adapter_method :update_instance
      adapter_method :save_instance
      adapter_method :delete_instance
      adapter_method :permitted_params
      adapter_method :decorate_collection
      adapter_method :sort
      adapter_method :paginate
      adapter_method :count

      attr_accessor :decorator

      def prepare_collection(params)
        collection = collection(params)
        collection = sort(collection, params)
        collection = paginate(collection, params)
        collection = decorate_collection(collection)
        collection
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
