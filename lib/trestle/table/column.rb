module Trestle
  class Table
    class Column
      attr_reader :table, :field, :options, :block

      def initialize(table, field, options={}, &block)
        @table, @field, @options = table, field, options
        @block = block if block_given?
      end

      def header(template)
        I18n.t("admin.table.header.#{field}", default: options[:header] || field.to_s.humanize.titleize)
      end

      def content(template, instance)
        if block
          template.instance_exec(instance, &block)
        else
          instance.send(field)
        end
      end

      def classes
        [options[:class], ("text-#{options[:align]}" if options[:align])].compact
      end

      def data
        options[:data]
      end

      module Formatting
        def content(template, instance)
          value = super

          case value
          when Time
            template.timestamp(value)
          when Date
            template.datestamp(value)
          else
            value
          end
        end
      end

      prepend Formatting
    end
  end
end
