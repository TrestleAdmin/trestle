module Trestle
  class Table
    class Builder < Trestle::Builder
      target :table

      def initialize(options={})
        @table = Table.new(options)
      end

      def row(options={}, &block)
        table.row = Row.new(options, &block)
      end

      def selectable_column
        table.columns << SelectColumn.new(table)
      end

      def column(field, proc=nil, options={}, &block)
        if proc.is_a?(Hash)
          options = proc
          proc = nil
        end

        table.columns << Column.new(table, field, options, &(proc || block))
      end

      def actions(&block)
        table.columns << ActionsColumn.new(table, &block)
      end
    end
  end
end
