module Trestle
  module Adapters
    class Adapter
      attr_reader :admin
      delegate :model, to: :admin

      def initialize(admin)
        @admin = admin
      end

      def collection(params={})
        raise NotImplementedError
      end

      def find_instance(params)
        raise NotImplementedError
      end

      def build_instance(attrs={}, params={})
        raise NotImplementedError
      end

      def update_instance(instance, attrs, params={})
        raise NotImplementedError
      end

      def save_instance(instance)
        raise NotImplementedError
      end

      def delete_instance(instance)
        raise NotImplementedError
      end

      def decorate_collection(collection)
        collection
      end

      def to_param(instance)
        instance
      end

      def unscope(scope)
        scope
      end

      def merge_scopes(scope, other)
        raise NotImplementedError
      end

      def count(collection)
        raise NotImplementedError
      end

      def sort(collection, params)
        raise NotImplementedError
      end

      def paginate(collection, params)
        collection = Kaminari.paginate_array(collection) unless collection.respond_to?(:page)
        collection.page(params[:page])
      end

      def permitted_params(params)
        params.require(admin.admin_name.singularize).permit!
      end

      def human_attribute_name(attribute, options = {})
        attribute.to_s.titleize
      end

      def default_table_attributes
        raise NotImplementedError
      end

      def default_form_attributes
        raise NotImplementedError
      end
    end
  end
end
