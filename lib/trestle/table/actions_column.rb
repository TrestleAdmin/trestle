module Trestle
  class Table
    class ActionsColumn
      attr_reader :table, :toolbar, :options

      def initialize(table, options={}, &block)
        @table, @options = table, options
        @toolbar = Toolbar.new(ActionsBuilder)

        if block_given?
          @toolbar.append(&block)
        else
          @toolbar.append(&default_actions)
        end
      end

      def renderer(template)
        Renderer.new(self, template)
      end

      def default_actions
        ->(toolbar, instance, admin) do
          toolbar.delete if admin && admin.actions.include?(:destroy)
        end
      end

      class ActionsBuilder < Toolbar::Builder
        attr_reader :instance, :admin

        def initialize(template, instance, admin)
          super(template)

          @instance, @admin = instance, admin
        end

        def show
          link(t("buttons.show", default: "Show"), instance, admin: admin, action: :show, icon: "fa fa-info", style: :info)
        end

        def edit
          link(t("buttons.edit", default: "Edit"), instance, admin: admin, action: :edit, icon: "fa fa-pencil", style: :warning)
        end

        def delete
          link(t("buttons.delete", default: "Delete"), instance, admin: admin, action: :destroy, method: :delete, icon: "fa fa-trash", style: :danger, data: { toggle: "confirm-delete", placement: "left" })
        end

        builder_method :show, :edit, :delete

        # Disallow button tags within the actions toolbar. Alias to link for backwards compatibility.
        alias button link

      private
        def translate(key, options={})
          if admin
            admin.translate(key, options)
          else
            I18n.t(:"admin.#{key}", options)
          end
        end
        alias t translate
      end

      class Renderer < Column::Renderer
        def header
          options[:header]
        end

        def classes
          super + ["actions"]
        end

        def content(instance)
          @template.render_toolbar(@column.toolbar, instance, table.admin)
        end
      end
    end
  end
end
