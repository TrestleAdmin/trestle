module Trestle
  class Resource
    class Builder < Admin::Builder
      self.admin_class = Resource
      self.controller = -> { ResourceController }

      def adapter(&block)
        klass = admin.adapter_class
        klass.class_eval(&block) if block_given?
        klass
      end

      def adapter=(adapter)
        admin.adapter_class = adapter
      end

      def collection(&block)
        admin.define_adapter_method(:collection, &block)
      end

      def find_instance(&block)
        admin.define_adapter_method(:find_instance, &block)
      end
      alias instance find_instance

      def build_instance(&block)
        admin.define_adapter_method(:build_instance, &block)
      end

      def update_instance(&block)
        admin.define_adapter_method(:update_instance, &block)
      end

      def save_instance(&block)
        admin.define_adapter_method(:save_instance, &block)
      end

      def delete_instance(&block)
        admin.define_adapter_method(:delete_instance, &block)
      end

      def to_param(&block)
        admin.define_adapter_method(:to_param, &block)
      end

      def params(&block)
        admin.define_adapter_method(:permitted_params, &block)
      end

      def decorator(decorator)
        admin.decorator = decorator
      end

      def decorate_collection(&block)
        admin.define_adapter_method(:decorate_collection, &block)
      end

      def merge_scopes(&block)
        admin.define_adapter_method(:merge_scopes, &block)
      end

      def sort(&block)
        admin.define_adapter_method(:sort, &block)
      end

      def sort_column(column, &block)
        admin.column_sorts[column.to_sym] = block
      end

      def paginate(options={}, &block)
        admin.pagination_options = admin.pagination_options.merge(options)
        admin.define_adapter_method(:paginate, &block)
      end

      def count(&block)
        admin.define_adapter_method(:count, &block)
      end

      def scopes(defaults: {}, **options, &block)
        defaults = defaults.merge(options.slice(:count))

        admin.scopes.apply_options!(options)
        admin.scopes.append(**defaults, &block) if block_given?
      end

      def scope(name, scope=nil, **options, &block)
        scopes do
          scope(name, scope, **options, &block)
        end
      end

      def return_to(options={}, &block)
        actions = options.key?(:on) ? Array(options[:on]) : [:create, :update, :destroy]

        actions.each do |action|
          admin.return_locations[action.to_sym] = block
        end
      end

    protected
      def normalize_table_options(name, options)
        if name.is_a?(Hash)
          # Default index table
          name, options = :index, name.reverse_merge(sortable: true)
        end

        [name, options.reverse_merge(admin: admin)]
      end
    end
  end
end
