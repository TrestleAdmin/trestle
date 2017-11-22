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
          table.admin.human_attribute_name(field)
        else
          field.to_s.humanize.titleize
        end
      end

      class Renderer
        delegate :options, :table, to: :@column

        def initialize(column, template)
          @column, @template = column, template
        end

        def header
          return if options.has_key?(:header) && options[:header].in?([nil, false])

          header = I18n.t("admin.table.headers.#{@column.field}", default: @column.header)
          header = @template.sort_link(header, @column.sort_field, @column.sort_options) if @column.sortable?
          header
        end

        def content(instance)
          value = column_value(instance)
          content = @template.format_value(value, options)

          if value.respond_to?(:id) && options[:link] != false
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
                @template.capture { @template.instance_exec(instance, &@column.block).to_s }
              }.call
            else
              @template.capture { @template.instance_exec(instance, &@column.block).to_s }
            end
          else
            instance.send(@column.field)
          end
        end
      end
    end
  end
end
