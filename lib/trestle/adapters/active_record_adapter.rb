module Trestle
  module Adapters
    module ActiveRecordAdapter
      def collection(params={})
        model.all
      end

      def find_instance(params)
        model.find(params[:id])
      end

      def build_instance(attrs={}, params={})
        model.new(attrs)
      end

      def update_instance(instance, attrs, params={})
        instance.assign_attributes(attrs)
      end

      def save_instance(instance, params={})
        instance.save
      end

      def delete_instance(instance, params={})
        instance.destroy
      end

      def merge_scopes(scope, other)
        scope.merge(other)
      end

      def count(collection)
        collection.count(:all)
      end

      def sort(collection, field, order)
        collection.reorder(field => order)
      end

      def human_attribute_name(attribute, options={})
        model.human_attribute_name(attribute, options)
      end

      def default_table_attributes
        default_attributes.reject do |attribute|
          inheritance_column?(attribute) || counter_cache_column?(attribute)
        end
      end

      def default_form_attributes
        default_attributes.reject do |attribute|
          primary_key?(attribute) || inheritance_column?(attribute) || counter_cache_column?(attribute) || excluded_attribute?(attribute)
        end
      end

    protected
      def default_attributes
        model.columns.map do |column|
          if column.name.end_with?("_id") && (name = column.name.sub(/_id$/, '')) && (reflection = model.reflections[name])
            Attribute::Association.new(column.name, class: -> { reflection.klass }, name: name, polymorphic: reflection.polymorphic?, type_column: reflection.foreign_type)
          elsif column.name.end_with?("_type") && (name = column.name.sub(/_type$/, '')) && (reflection = model.reflections[name])
            # Ignore type columns for polymorphic associations
          elsif enum_column?(column)
            Attribute.new(column.name, :enum, values: enum_values(column))
          else
            Attribute.new(column.name, column.type, array_column?(column) ? { array: true } : {})
          end
        end.compact
      end

      def primary_key?(attribute)
        attribute.name.to_s == model.primary_key
      end

      def inheritance_column?(attribute)
        attribute.name.to_s == model.inheritance_column
      end

      def counter_cache_column?(attribute)
        attribute.name.to_s.end_with?("_count")
      end

      def excluded_attribute?(attribute)
        admin.excluded_form_attributes.include?(attribute.name.to_sym)
      end

      def array_column?(column)
        column.respond_to?(:array?) && column.array?
      end

      def enum_column?(column)
        model.defined_enums.key?(column.name)
      end

      def enum_values(column)
        model.defined_enums[column.name].map { |key, value|
          [key, enum_human_name(column, key)]
        }
      end

      def enum_human_name(column, value)
        human_attribute_name([column.name.pluralize, value].join("."), default: value.humanize)
      end
    end
  end
end
