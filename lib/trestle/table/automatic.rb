module Trestle
  class Table
    class Automatic < Table
      def initialize(admin)
        super()
        @admin = admin
      end

      def columns
        @admin.default_columns.map.with_index do |(name, type), index|
          Column.new(self, name.to_sym, link: index.zero?, align: ("center" if [:datetime, :time, :date].include?(type)))
        end
      end
    end
  end
end
