module Trestle
  class Table
    require_relative "table/automatic"
    require_relative "table/builder"
    require_relative "table/column"
    require_relative "table/actions_column"
    require_relative "table/select_column"
    require_relative "table/row"

    attr_reader :columns
    attr_writer :row
    attr_accessor :options

    def initialize(options={})
      @options = options
      @columns = []
    end

    def with_options(opts={})
      dup.tap do |table|
        table.options = options.merge(opts)
      end
    end

    def admin
      Trestle.lookup(options[:admin]) if options.key?(:admin)
    end

    def sortable?
      options[:sortable] == true
    end

    def autolink?
      options[:autolink] != false
    end

    def header?
      options[:header] != false
    end

    def renderer(template)
      Renderer.new(self, template)
    end

    def row
      @row || Row.new
    end

    class Renderer
      delegate :options, :header?, to: :@table

      def initialize(table, template)
        @table, @template = table, template
      end

      def row
        @row ||= @table.row.renderer(table: @table, template: @template)
      end

      def columns
        @columns ||= row.columns
      end

      def id
        options[:id]
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
