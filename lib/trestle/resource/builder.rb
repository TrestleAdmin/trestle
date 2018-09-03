module Trestle
  class Resource
    class Builder < Admin::Builder
      self.admin_class = Resource
      self.controller = Controller

      def adapter(&block)
        klass = admin.adapter_class
        klass.class_eval(&block) if block_given?
        klass
      end

      def adapter=(adapter)
        admin.adapter_class = adapter
      end

      def remove_action(*actions)
        actions.each do |action|
          controller.remove_possible_method(action.to_sym)
          admin.actions.delete(action.to_sym)
        end
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

      def scope(name, scope=nil, options={}, &block)
        if scope.is_a?(Hash)
          options = scope
          scope = nil
        end

        admin.scopes[name] = Scope.new(admin, name, options, &(scope || block))
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
