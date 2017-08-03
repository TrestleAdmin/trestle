module Trestle
  class Table
    class ActionsColumn
      attr_reader :table, :block

      def initialize(table, &block)
        @table = table
        @block = block_given? ? block : default_actions
      end

      def renderer(template)
        Renderer.new(self, template)
      end

      def default_actions
        ->(action) do
          action.delete
        end
      end

      class ActionsBuilder
        attr_reader :instance

        delegate :table, to: :@column

        def initialize(column, template, instance)
          @column, @template, @instance = column, template, instance
        end

        def delete
          button(@template.icon("fa fa-trash"), @template.admin_url_for(instance, admin: table.options[:admin], action: :destroy), method: :delete, class: "btn-danger", data: { toggle: "confirm-delete", placement: "left" })
        end

        def button(content, url, options={})
          options[:class] = Array(options[:class])
          options[:class] << "btn" unless options[:class].include?("btn")

          @template.concat @template.link_to(content, url, options)
        end
        alias_method :link, :button
      end

      class Renderer < Column::Renderer
        def header
        end

        def classes
          "actions"
        end

        def options
          {}
        end

        def data
          {}
        end

        def content(instance)
          builder = ActionsBuilder.new(@column, @template, instance)

          @template.with_output_buffer do
            @template.instance_exec(builder, &@column.block)
          end
        end
      end
    end
  end
end
