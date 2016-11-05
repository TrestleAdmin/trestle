module Trestle
  module Adapters
    module ActiveRecordAdapter
      def collection(params={})
        admin.model.all
      end

      def find_instance(params)
        admin.model.find(params[:id])
      end

      def build_instance(params={})
        admin.model.new(params)
      end

      def update_instance(instance, params)
        instance.assign_attributes(params)
      end

      def save_instance(instance)
        instance.save
      end

      def delete_instance(instance)
        instance.destroy
      end

      def sort(collection, params)
        if params[:sort]
          collection.reorder(params[:sort] => params[:order] || "asc")
        else
          collection
        end
      end

      def paginate(collection, params)
        collection = Kaminari.paginate_array(collection) unless collection.respond_to?(:page)
        collection.page(params[:page])
      end

      def count(collection)
        collection.count
      end
    end
  end
end
