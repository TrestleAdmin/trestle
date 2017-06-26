module Trestle
  class Table
    class Automatic < Table
      def initialize(admin)
        super(sortable: true)
        @admin = admin
      end

      def columns
        content_columns + [actions_column]
      end

      def content_columns
        @admin.default_attributes.map.with_index do |attribute, index|
          next if attribute.inheritance_column?
          next if attribute.counter_cache?

          if attribute.association?
            Column.new(self, attribute.association_name, sort: false)
          elsif attribute.text?
            Column.new(self, attribute.name, link: index.zero?) do |instance|
              truncate(instance.public_send(attribute.name))
            end
          else
            Column.new(self, attribute.name, link: index.zero?, align: (:center if attribute.datetime? || attribute.boolean?))
          end
        end.compact
      end

      def actions_column
        ActionsColumn.new(self)
      end
    end
  end
end
