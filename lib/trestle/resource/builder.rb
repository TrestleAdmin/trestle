module Trestle
  class Resource
    class Builder < Admin::Builder
      self.admin_class = Resource
      self.controller = Controller

      def adapter(&block)
        klass = admin.adapter
        klass.instance_eval(&block) if block_given?
        klass
      end

      def adapter=(adapter)
        admin.adapter = adapter
      end

      def collection(&block)
        admin.collection = block
      end

      def instance(&block)
        admin.find_instance = block
      end

      def build_instance(&block)
        admin.build_instance = block
      end

      def update_instance(&block)
        admin.update_instance = block
      end

      def save_instance(&block)
        admin.save_instance = block
      end

      def delete_instance(&block)
        admin.delete_instance = block
      end

      def to_param(&block)
        admin.to_param = block
      end

      def params(&block)
        admin.permitted_params = block
      end

      def decorator(decorator)
        admin.decorator = decorator
      end

      def decorate_collection(&block)
        admin.decorate_collection = block
      end

      def sort(&block)
        admin.sort = block
      end

      def paginate(&block)
        admin.paginate = block
      end

      def count(&block)
        admin.count = block
      end

      def scope(name, options={}, &block)
        admin.scopes[name] = Scope.new(admin, name, options, &block)
      end
    end
  end
end
