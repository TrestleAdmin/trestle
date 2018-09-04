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

    # Declares a method that is handled by the admin's adapter class.
    def self.adapter_method(name)
      delegate name, to: :adapter

      singleton_class.class_eval do
        delegate name, to: :adapter
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

    # Delegate all missing methods to corresponding class method if available
    def method_missing(name, *args, &block)
      if self.class.respond_to?(name)
        self.class.send(name, *args, &block)
      else
        super
      end
    end

    class << self
      # Returns the adapter class for this admin.
      #
      # Defaults to a subclass of `Trestle.config.default_adapter` with
      # the admin-specific adapter methods module included.
      def adapter_class
        @adapter_class ||= Class.new(Trestle.config.default_adapter).include(adapter_methods)
      end

      # Sets an explicit adapter class for this admin.
      # A subclass is created with the admin-specific adapter methods module included.
      def adapter_class=(klass)
        @adapter_class = Class.new(klass).include(adapter_methods)
      end

      # Unbound instance of adapter.
      def adapter
        @adapter ||= adapter_class.new(self)
      end

      # Module container for admin-specific adapter methods.
      def adapter_methods
        @adapter_methods ||= Module.new
      end

      # Defines an admin-specific adapter method.
      #
      # The given block is wrapped rather than passed to #define_method directly, so that
      # adapter methods can be defined with incomplete block parameters. Unfortunately
      # this means we lose the ability to call super from within a custom adapter method.
      def define_adapter_method(name, &block)
        adapter_methods.define_method(name) do |*args|
          instance_exec(*args, &block)
        end
      end

      def prepare_collection(params, options={})
        Collection.new(self, options).prepare(params)
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

      def root_action
        singular? ? :show : :index
      end

      def readonly?
        options[:readonly]
      end

      def singular?
        options[:singular]
      end

      def translate(key, options={})
        super(key, options.merge({
          model_name:            model_name.titleize,
          lowercase_model_name:  model_name.downcase,
          pluralized_model_name: model_name.plural.titleize
        }))
      end
      alias t translate

      def instance_path(instance, options={})
        action = options.fetch(:action) { :show }
        options = options.merge(id: to_param(instance)) unless singular?

        path(action, options)
      end

      def routes
        admin = self

        resource_method  = singular? ? :resource : :resources
        resource_name    = admin_name
        resource_options = {
          controller: controller_namespace,
          as:         route_name,
          path:       options[:path],
          except:     (RESOURCE_ACTIONS - actions)
        }

        Proc.new do
          public_send(resource_method, resource_name, resource_options) do
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

      def validate!
        if singular? && !adapter_methods.method_defined?(:find_instance)
          raise NotImplementedError, "Singular resources must define an instance block."
        end
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
