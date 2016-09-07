module Trestle
  class Resource
    class Builder < Admin::Builder
      self.admin_class = Resource
      self.controller = Controller

      def collection(&block)
        admin.collection = block
      end

      def instance(&block)
        admin.instance = block
      end

      def paginate(&block)
        admin.paginate = block
      end

      def decorator(decorator)
        admin.decorator = decorator
      end
    end
  end
end
