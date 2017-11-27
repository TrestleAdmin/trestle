module Trestle
  class Table
    class ActionsColumn
      attr_reader :table, :options, :block

      def initialize(table, options={}, &block)
        @table, @options = table, options
        @block = block_given? ? block : default_actions
      end

      def renderer(template)
        Renderer.new(self, template)
      end

      def default_actions
        admin = table.admin

        ->(action) do
          action.delete if admin && admin.actions.include?(:destroy)
        end
      end

      class ActionsBuilder
        attr_reader :instance

        delegate :table, to: :@column

        delegate :concat, :icon, :link_to, :admin_url_for, :admin_link_to, to: :@template

        def initialize(column, template, instance)
          @column, @template, @instance = column, template, instance
        end

        def show
          button(icon("fa fa-info"), instance, action: :show, class: "btn-info")
        end

        def edit
          button(icon("fa fa-pencil"), instance, action: :edit, class: "btn-warning")
        end

        def delete
          button(icon("fa fa-trash"), instance, action: :destroy, method: :delete, class: "btn-danger", data: { toggle: "confirm-delete", placement: "left" })
        end

        def button(content, instance_or_url, options={})
          options[:class] = Array(options[:class])
          options[:class] << "btn" unless options[:class].include?("btn")

          concat admin_link_to(content, instance_or_url, options.reverse_merge(admin: table.admin))
        end
        alias_method :link, :button
      end

      class Renderer < Column::Renderer
        def header
          options[:header]
        end

        def classes
          super + ["actions"]
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
