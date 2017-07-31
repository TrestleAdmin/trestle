module Trestle
  class Table
    extend ActiveSupport::Autoload

    autoload :Automatic
    autoload :Builder
    autoload :Column
    autoload :ActionsColumn
    autoload :SelectColumn
    autoload :Row

    attr_reader :columns, :options
    attr_writer :row

    def initialize(options={})
      @options = options
      @columns = []
    end

    def sortable?
      options[:sortable] == true
    end

    def renderer(template)
      Renderer.new(self, template)
    end

    def row
      @row || Row.new
    end

    class Renderer
      delegate :options, to: :@table

      def initialize(table, template)
        @table, @template = table, template
      end

      def row
        @row ||= @table.row.renderer(@template)
      end

      def columns
        @columns ||= @table.columns.map { |column| column.renderer(@template) }
      end

      def classes
        ["trestle-table", options[:class]].compact
      end

      def data
        options[:data]
      end
    end
  end
end
