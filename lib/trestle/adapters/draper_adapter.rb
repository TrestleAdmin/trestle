module Trestle
  module Adapters
    module DraperAdapter
      def decorate_collection(collection)
        if decorator = admin.decorator
          decorator.decorate_collection(collection)
        else
          super
        end
      end
    end
  end
end
