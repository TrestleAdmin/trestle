module Trestle
  class Table
    class Automatic < Table
      def initialize(admin)
        super()
        @admin = admin
      end

      def columns
        content_columns + [actions_column]
      end

      def content_columns
        @admin.default_columns.map.with_index do |(name, type), index|
          Column.new(self, name.to_sym, link: index.zero?, align: ("center" if [:datetime, :time, :date].include?(type)))
        end
      end

      def actions_column
        ActionsColumn.new(self)
      end
    end
  end
end
