module Trestle
  class Resource
    class Builder < Admin::Builder
      self.admin_class = Resource
      self.controller = Controller

      def collection(&block)
        admin.collection = block
      end
    end
  end
end
