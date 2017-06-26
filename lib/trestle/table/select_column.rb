module Trestle
  class Table
    class SelectColumn
      attr_reader :table

      def initialize(table)
        @table = table
      end

      def renderer(template)
        Renderer.new(self, template)
      end

      class Renderer < Column::Renderer
        def header
          @template.check_box_tag ""
        end

        def content(instance)
          @template.check_box_tag "selected[]", instance.to_param, false, id: nil
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
end
