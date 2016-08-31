module Trestle
  class Table
    class Builder < Trestle::Builder
      target :table

      def initialize(options={})
        @table = Table.new(options)
        @output_buffer = ActionView::OutputBuffer.new
      end

      def selectable_column
        table.columns << SelectColumn.new(table)
      end

      def column(field, options={}, &block)
        table.columns << Column.new(table, field, options, &block)
      end

      def actions(&block)
        table.columns << ActionsColumn.new(table, &block)
      end
    end
  end
end
