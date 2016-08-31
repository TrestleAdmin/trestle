module Trestle
  class Table
    class ActionsColumn
      attr_reader :table, :block

      def initialize(table, &block)
        @table = table
        @block = block if block_given?
      end

      def header(template)
      end

      def content(template, instance)
        template.instance_exec(instance, &block)
      end

      def classes
        "actions"
      end

      def data
        {}
      end
    end
  end
end
