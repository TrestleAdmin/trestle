module Trestle
  class Table
    class Automatic < Table
      def initialize(admin)
        super(sortable: true, admin: admin)
      end

      def columns
        content_columns + [actions_column]
      end

      def content_columns
        admin.default_table_attributes.map.with_index do |attribute, index|
          case attribute.type
          when :association
            Column.new(attribute.association_name, sort: false)
          when :enum
            Column.new(attribute.name, align: :center, sort: attribute.name) do |instance|
              if value = instance.public_send(attribute.name)
                full_attribute_name = [attribute.name.to_s.pluralize, value].join(".")
                status_tag(admin.human_attribute_name(full_attribute_name, default: value.humanize))
              end
            end
          else
            Column.new(attribute.name, link: index.zero?, align: (:center if [:datetime, :boolean].include?(attribute.type)))
          end
        end
      end

      def actions_column
        ActionsColumn.new
      end
    end
  end
end
