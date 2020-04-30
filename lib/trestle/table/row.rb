module Trestle
  class Table
    class Row
      attr_reader :options, :block

      def initialize(options={}, &block)
        @options = options
        @block = block if block_given?
      end

      def renderer(table:, template:)
        Renderer.new(self, table: table, template: template)
      end

      class Renderer
        def initialize(row, table:, template:)
          @row, @table, @template = row, table, template
        end

        def columns
          @table.columns.map { |column|
            column.renderer(table: @table, template: @template)
          }.select(&:render?)
        end

        def render(instance)
          @template.content_tag(:tr, options(instance)) do
            @template.safe_join(columns.map { |column| column.render(instance) }, "\n")
          end
        end

        def options(instance)
          options = Trestle::Options.new

          if @table.admin && @table.autolink? && @table.admin.actions.include?(:show)
            options.merge!(data: { url: admin_url_for(instance) })
            options.merge!(data: { behavior: "dialog" }) if @table.admin.form.dialog?
          end

          options.merge!(@row.options)
          options.merge!(@template.instance_exec(instance, &@row.block)) if @row.block

          options
        end

      protected
        def admin_url_for(instance)
          @template.admin_url_for(instance, admin: @table.admin)
        end
      end
    end
  end
end
