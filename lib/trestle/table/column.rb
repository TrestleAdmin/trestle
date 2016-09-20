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
          sortable? ? template.sort_link(header_text, sort_field) : header_text
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

      def sortable?
        table.sortable? && options[:sort] != false && (!@block || options.has_key?(:sort))
      end

    private
      def header_text
        I18n.t("admin.table.header.#{field}", default: options[:header] || field.to_s.humanize.titleize)
      end

      def sort_field
        options[:sort] || field
      end

      module Formatting
        def content(template, instance)
          value = super

          if options[:format]
            format_from_options(template, value)
          else
            autoformat_value(template, value)
          end
        end

      private
        def format_from_options(template, value)
          case options[:format]
          when :currency
            template.number_to_currency(value)
          else
            value
          end
        end

        def autoformat_value(template, value)
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
        def admin
          admin = options[:admin] || table.options[:admin]
          return unless admin

          if admin.is_a?(Class) && admin < Admin
            admin
          else
            Trestle.admins[admin.to_s]
          end
        end

        def content(template, instance)
          if options[:link]
            content = super
            admin = self.admin || template.admin

            if content.blank?
              template.link_to "None set", admin.path(:show, id: instance), class: "empty"
            else
              template.link_to content, admin.path(:show, id: instance)
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
