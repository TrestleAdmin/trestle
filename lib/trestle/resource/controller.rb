module Trestle
  class Resource
    class Controller < Admin::Controller
    protected
      def instance
        admin.instance(params)
      end
      helper_method :instance

      def collection
        admin.collection
      end
      helper_method :collection

      def paginated_collection
        admin.paginate(collection, params)
      end
      helper_method :paginated_collection

      def decorated_collection
        admin.decorate(paginated_collection)
      end
      helper_method :decorated_collection
    end
  end
end
