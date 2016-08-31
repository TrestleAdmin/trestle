module Trestle
  class Table
    class SelectColumn
      attr_reader :table

      def initialize(table)
        @table = table
      end

      def header(template)
        template.check_box_tag ""
      end

      def content(template, instance)
        template.check_box_tag "selected[]", instance.to_param, false, id: nil
      end

      def classes
        "select-row"
      end

      def data
        {}
      end
    end
  end
end
