module Trestle
  class Table
    class SelectColumn
      attr_reader :options

      def initialize(options={})
        @options = options
      end

      def renderer(table:, template:)
        Renderer.new(self, table: table, template: template)
      end

      class Renderer < Column::Renderer
        def header
          checkbox "", nil, id: checkbox_id("all")
        end

        def content(instance)
          checkbox "selected[]", instance.to_param, id: checkbox_id(instance.to_param)
        end

        def classes
          "select-row"
        end

        def data
          {}
        end

      private
        def checkbox_id(param)
          [@table.options[:id], "select", param].compact.join("-")
        end

        def checkbox(name, value="1", options={})
          @template.check_box_tag(name, value, false, options.merge(class: "form-check-input"))
        end
      end
    end
  end
end
