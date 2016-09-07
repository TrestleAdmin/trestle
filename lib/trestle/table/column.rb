module Trestle
  class Table
    class Column
      attr_reader :table, :field, :options, :block

      def initialize(table, field, options={}, &block)
        @table, @field, @options = table, field, options
        @block = block if block_given?
      end

      def header(template)
        unless options.has_key?(:header) && options[:header].in?([nil, false])
          I18n.t("admin.table.header.#{field}", default: options[:header] || field.to_s.humanize.titleize)
        end
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

      module Linking
        def content(template, instance)
          if options[:link]
            content = super

            if content.blank?
              template.link_to "None set", template.admin.path(:show, id: instance), class: "empty"
            else
              template.link_to content, template.admin.path(:show, id: instance)
            end
          else
            super
          end
        end
      end
      prepend Linking
    end
  end
end
