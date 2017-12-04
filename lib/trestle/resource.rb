module Trestle
  class Resource < Admin
    extend ActiveSupport::Autoload

    autoload :Builder
    autoload :Controller

    RESOURCE_ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]
    READONLY_ACTIONS = [:index, :show]

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

      adapter_method :collection
      adapter_method :find_instance
      adapter_method :build_instance
      adapter_method :update_instance
      adapter_method :save_instance
      adapter_method :delete_instance
      adapter_method :to_param
      adapter_method :permitted_params
      adapter_method :decorate_collection
      adapter_method :unscope
      adapter_method :merge_scopes
      adapter_method :count
      adapter_method :sort
      adapter_method :paginate
      adapter_method :human_attribute_name
      adapter_method :default_table_attributes
      adapter_method :default_form_attributes

      attr_accessor :decorator

      def prepare_collection(params)
        collection = initialize_collection(params)
        collection = apply_scopes(collection, params)
        collection = apply_sorting(collection, params)
        collection = paginate(collection, params)
        collection = decorate_collection(collection)
        collection
      end

      def initialize_collection(params)
        collection(params)
      end

      def scopes
        @scopes ||= {}
      end

      def apply_scopes(collection, params)
        unscoped = unscope(collection)

        scopes_for(params).each do |scope|
          collection = merge_scopes(collection, scope.apply(unscoped))
        end

        collection
      end

      def scopes_for(params)
        result = []

        if params[:scope] && scopes.has_key?(params[:scope].to_sym)
          result << scopes[params[:scope].to_sym]
        end

        if result.empty? && default_scope = scopes.values.find(&:default?)
          result << default_scope
        end

        result
      end

      def column_sorts
        @column_sorts ||= {}
      end

      def apply_sorting(collection, params)
        return collection unless params[:sort]

        field = params[:sort].to_sym
        order = params[:order].to_s.downcase == "desc" ? :desc : :asc

        if column_sorts.has_key?(field)
          instance_exec(collection, order, &column_sorts[field])
        else
          sort(collection, field, order)
        end
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

      def default_breadcrumb
        Breadcrumb.new(I18n.t("admin.breadcrumbs.#{admin_name}", default: model_name.plural.titleize), path)
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
        @return_locations ||= {
          create:  Proc.new { |instance| path(:show, id: to_param(instance)) },
          update:  Proc.new { |instance| path(:show, id: to_param(instance)) },
          destroy: Proc.new { path(:index) }
        }
      end

      def return_location(action, instance=nil)
        instance_exec(instance, &return_locations[action])
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
