module Trestle
  class Resource < Admin
    require_relative "resource/adapter_methods"
    require_relative "resource/builder"
    require_relative "resource/collection"
    require_relative "resource/toolbar"

    include AdapterMethods

    RESOURCE_ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]
    READONLY_ACTIONS = [:index, :show]

    class_attribute :decorator

    class_attribute :pagination_options
    self.pagination_options = {}

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

    # Prepares a collection for use in the resource controller's index action.
    #
    # Applies scopes, sorts, pagination, finalization and decorators according
    # to the admin's adapter and any admin-specific adapter methods.
    def prepare_collection(params, options={})
      Collection.new(self, options).prepare(params)
    end

    # Evaluates the admin's scope block(s) using the adapter context
    # and returns a hash of Scope objects keyed by the scope name.
    def scopes
      @scopes ||= Scopes.new(self.class.scopes, adapter)
    end

    class << self
      # Deprecated: use instance method instead
      def prepare_collection(params, options={})
        Collection.new(self, options).prepare(params)
      end

      def scopes
        @scopes ||= Scopes::Definition.new
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

      def default_human_admin_name
        model_name.plural
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
            admin.additional_routes.each do |block|
              instance_exec(&block)
            end
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
        scope = respond_to?(:module_parent) ? module_parent : parent
        scope.const_get(admin_name.classify)
      rescue NameError
        raise NameError, "Unable to find model #{admin_name.classify}. Specify a different model using Trestle.resource(:#{admin_name}, model: MyModel)"
      end
    end
  end
end
