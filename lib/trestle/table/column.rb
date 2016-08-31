module Trestle
  class Table
    class Column
      attr_reader :table, :field, :options, :block

      def initialize(table, field, options={}, &block)
        @table, @field, @options = table, field, options
        @block = block if block_given?
      end

      def header(template)
        I18n.t("admin.table.header.#{field}", default: options[:header] || field.to_s.humanize)
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
    end
  end
end
