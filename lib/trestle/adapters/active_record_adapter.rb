module Trestle
  module Adapters
    module ActiveRecordAdapter
      def collection(params={})
        admin.model.all
      end

      def find_instance(params)
        admin.model.find(params[:id])
      end

      def build_instance(attrs={}, params={})
        admin.model.new(attrs)
      end

      def update_instance(instance, attrs, params={})
        instance.assign_attributes(attrs)
      end

      def save_instance(instance)
        instance.save
      end

      def delete_instance(instance)
        instance.destroy
      end

      def unscope(scope)
        scope.respond_to?(:unscoped) ? scope.unscoped : scope
      end

      def merge_scopes(scope, other)
        scope.merge(other)
      end

      def sort(collection, field, order)
        collection.reorder(field => order)
      end

      def count(collection)
        collection.count
      end

      def default_table_attributes
        default_attributes.reject do |attribute|
          attribute.inheritance_column? || attribute.counter_cache?
        end
      end

      def default_form_attributes
        default_attributes.reject do |attribute|
          attribute.primary_key? || attribute.inheritance_column? || attribute.counter_cache?
        end
      end

    protected
      def default_attributes
        admin.model.columns.map do |column|
          if column.name.end_with?("_id") && (reflection = admin.model.reflections[column.name.sub(/_id$/, '')])
            Attribute::Association.new(admin, column.name, reflection.klass)
          else
            Attribute.new(admin, column.name, column.type)
          end
        end
      end
    end
  end
end
