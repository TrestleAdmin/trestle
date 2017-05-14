module Trestle
  module Adapters
    extend ActiveSupport::Autoload

    autoload :ActiveRecordAdapter
    autoload :DraperAdapter

    class Adapter
      attr_reader :admin

      def initialize(admin)
        @admin = admin
      end

      def collection(params={})
        raise NotImplementedError
      end

      def find_instance(params)
        raise NotImplementedError
      end

      def build_instance(params={})
        raise NotImplementedError
      end

      def update_instance(instance, params)
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

      def merge_scopes(scope, other)
        raise NotImplementedError
      end

      def sort(collection, params)
        raise NotImplementedError
      end

      def paginate(collection, params)
        raise NotImplementedError
      end

      def count(collection)
        raise NotImplementedError
      end

      def permitted_params(params)
        params.require(admin.admin_name.singularize).permit!
      end

      def default_attributes
        raise NotImplementedError
      end

      # Creates a new Adapter class with the given modules mixed in
      def self.compose(*modules)
        Class.new(self) do
          modules.each { |mod| include(mod) }
        end
      end
    end
  end
end
