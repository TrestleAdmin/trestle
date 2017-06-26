module Trestle
  class Table
    class Column
      attr_reader :table, :field, :options, :block

      def initialize(table, field, options={}, &block)
        @table, @field, @options = table, field, options
        @block = block if block_given?
      end

      def renderer(template)
        Renderer.new(self, template)
      end

      def sortable?
        table.sortable? && options[:sort] != false && (!@block || options.has_key?(:sort))
      end

      def sort_field
        if options[:sort].is_a?(Hash)
          options[:sort][:field] || field
        else
          options[:sort] || field
        end
      end

      def sort_options
        options[:sort].is_a?(Hash) ? options[:sort] : {}
      end

      class Renderer
        delegate :options, to: :@column

        def initialize(column, template)
          @column, @template = column, template
        end

        def header
          return if options.has_key?(:header) && options[:header].in?([nil, false])

          header = I18n.t("admin.table.headers.#{@column.field}", default: options[:header] || @column.field.to_s.humanize.titleize)
          header = @template.sort_link(header, @column.sort_field, @column.sort_options) if @column.sortable?
          header
        end

        def content(instance)
          value = column_value(instance)

          return blank_column(instance) if value.nil?

          content = format_column(value)

          if value.respond_to?(:id) && options[:link] != false
            # Automatically link to instance's admin if available
            content = @template.admin_link_to(content, value)
          elsif options[:link]
            # Explicitly link to the specified admin, or the table's admin
            content = @template.admin_link_to(content, instance, admin: options[:admin] || @column.table.options[:admin])
          end

          content
        end

        def classes
          [options[:class], ("text-#{options[:align]}" if options[:align])].compact
        end

        def data
          options[:data]
        end

      private
        def column_value(instance)
          if @column.block
            @template.instance_exec(instance, &@column.block)
          else
            instance.send(@column.field)
          end
        end

        def blank_column(value)
          text = options.key?(:blank) ? options[:blank] : I18n.t("admin.table.column.blank")
          @template.content_tag(:span, text, class: "blank")
        end

        def format_column(value)
          if options[:format]
            format_from_options(value)
          else
            autoformat_value(value)
          end
        end

        def format_from_options(value)
          case options[:format]
          when :currency
            @template.number_to_currency(value)
          else
            value
          end
        end

        def autoformat_value(value)
          case value
          when Time
            @template.timestamp(value)
          when Date, DateTime
            @template.datestamp(value)
          when TrueClass, FalseClass
            @template.status_tag(@template.icon("fa fa-check"), :success) if value
          when ->(value) { value.respond_to?(:id) }
            @template.display(value)
          else
            value
          end
        end
      end
    end
  end
end
