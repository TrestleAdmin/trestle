module Trestle
  class Resource < Admin
    extend ActiveSupport::Autoload

    autoload :Builder
    autoload :Collection
    autoload :Controller

    RESOURCE_ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]
    READONLY_ACTIONS = [:index, :show]

    class_attribute :decorator

    class_attribute :pagination_options
    self.pagination_options = {}

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
        block_method = :"#{name}_block"
        attr_accessor block_method

        define_method(name) do |*args|
          if override = public_send(block_method)
            instance_exec(*args, &override)
          else
            adapter.public_send(name, *args)
          end
        end
      end

      # Collection-focused adapter methods
      adapter_method :collection
      adapter_method :merge_scopes
      adapter_method :sort
      adapter_method :paginate
      adapter_method :finalize_collection
      adapter_method :decorate_collection
      adapter_method :count

      # Instance-focused adapter methods
      adapter_method :find_instance
      adapter_method :build_instance
      adapter_method :update_instance
      adapter_method :save_instance
      adapter_method :delete_instance
      adapter_method :permitted_params

      # Common adapter methods
      adapter_method :to_param
      adapter_method :human_attribute_name

      # Automatic tables and forms adapter methods
      adapter_method :default_table_attributes
      adapter_method :default_form_attributes

      def prepare_collection(params)
        Collection.new(self).prepare(params)
      end

      def initialize_collection(params)
        collection(params)
      end

      def scopes
        @scopes ||= {}
      end

      def column_sorts
        @column_sorts ||= {}
      end

      def table
        super || Table::Automatic.new(self)
      end

      def form
        super || Form::Automatic.new(self)
      end

      def model
        @model ||= options[:model] || infer_model_class
      end

      def model_name
        @model_name ||= Trestle::ModelName.new(model)
      end

      def actions
        @actions ||= (readonly? ? READONLY_ACTIONS : RESOURCE_ACTIONS).dup
      end

      def readonly?
        options[:readonly]
      end

      def instance_path(instance, options={})
        action = options.fetch(:action) { :show }
        path(action, options.merge(id: to_param(instance)))
      end

      def routes
        admin = self

        Proc.new do
          resources admin.admin_name, controller: admin.controller_namespace, as: admin.route_name, path: admin.options[:path], except: (RESOURCE_ACTIONS - admin.actions) do
            instance_exec(&admin.additional_routes) if admin.additional_routes
          end
        end
      end

      def return_locations
        @return_locations ||= {}
      end

      def build(&block)
        Resource::Builder.build(self, &block)
      end

    private
      def infer_model_class
        parent.const_get(admin_name.classify)
      rescue NameError
        raise NameError, "Unable to find model #{admin_name.classify}. Specify a different model using Trestle.resource(:#{admin_name}, model: MyModel)"
      end
    end
  end
end
