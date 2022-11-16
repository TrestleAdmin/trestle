module Trestle
  class Table
    class Column
      attr_reader :field, :options, :block

      def initialize(field, options={}, &block)
        @field, @options = field, options
        @block = block if block_given?
      end

      def renderer(table:, template:)
        Renderer.new(self, table: table, template: template)
      end

      def sortable?
        options[:sort] != false && (!@block || options.has_key?(:sort))
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

        def initialize(column, table:, template:)
          @column, @table, @template = column, table, template
        end

        def render(instance)
          @template.content_tag(:td, content(instance), class: classes, data: data)
        end

        def render?
          if options.key?(:if)
            if options[:if].respond_to?(:call)
              @template.instance_exec(&options[:if])
            else
              options[:if]
            end
          elsif options.key?(:unless)
            if options[:unless].respond_to?(:call)
              !@template.instance_exec(&options[:unless])
            else
              !options[:unless]
            end
          else
            true
          end
        end

        def header
          return if options.key?(:header) && options[:header].in?([nil, false])

          if @table.sortable? && @column.sortable?
            @template.sort_link(header_text, @column.sort_field, @column.sort_options)
          else
            header_text
          end
        end

        def content(instance)
          value = column_value(instance)
          content = @template.format_value(value, options)

          if value.respond_to?(:id) && options[:link] != false
            # Column value was a model instance (e.g. from an association).
            # Automatically link to instance's admin if available
            content = @template.admin_link_to(content, value)
          elsif options[:link]
            # Explicitly link to the specified admin, or the table's admin
            content = @template.admin_link_to(content, instance, admin: options[:admin] || @table.admin)
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
        def header_text
          if header = options[:header]
            if header.respond_to?(:call)
              @template.instance_exec(&header)
            else
              header
            end
          elsif @table.admin
            @table.admin.t("table.headers.#{@column.field}", default: @table.admin.human_attribute_name(@column.field))
          else
            I18n.t("admin.table.headers.#{@column.field}", default: @column.field.to_s.humanize.titleize)
          end
        end

        def column_value(instance)
          if @column.block
            if block_is_legacy_haml?
              # In order for table column blocks to work properly within Haml templates,
              # the _hamlout local variable needs to be defined in the scope of the block,
              # so that the Haml version of the capture method is used. Because we
              # evaluate the block using instance_exec, we need to set this up manually.
              -> {
                _hamlout = eval('_hamlout', @column.block.binding)
                value = nil
                buffer = @template.capture { value = @template.instance_exec(instance, &@column.block) }
                value.is_a?(String) ? buffer : value
              }.call
            else
              # Capture both the immediate value and captured output of the block.
              # If the result of the block is a string, then use the contents of the buffer.
              # Otherwise return the result of the block as a raw value (for auto-formatting).
              value = nil
              buffer = @template.capture { value = @template.instance_exec(instance, &@column.block) }
              value.is_a?(String) ? buffer : value
            end
          else
            instance.send(@column.field)
          end
        end

        def block_is_legacy_haml?
          defined?(Haml) && Haml::Helpers.respond_to?(:block_is_haml?) && Haml::Helpers.block_is_haml?(@column.block)
        end
      end
    end
  end
end
