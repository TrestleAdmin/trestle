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

      def header
        if options[:header]
          options[:header]
        elsif table.admin
          table.admin.t("table.headers.#{field}", default: table.admin.human_attribute_name(field))
        else
          I18n.t("admin.table.headers.#{field}", default: field.to_s.humanize.titleize)
        end
      end

      class Renderer
        delegate :options, :table, to: :@column

        def initialize(column, template)
          @column, @template = column, template
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

          header = @column.header
          header = @template.instance_exec(&header) if header.respond_to?(:call)
          header = @template.sort_link(header, @column.sort_field, @column.sort_options) if @column.sortable?
          header
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
            content = @template.admin_link_to(content, instance, admin: options[:admin] || table.admin)
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
            if defined?(Haml) && Haml::Helpers.block_is_haml?(@column.block)
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
      end
    end
  end
end
