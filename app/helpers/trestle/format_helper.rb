module Trestle
  module FormatHelper
    def format_value(value, options={})
      if options.key?(:format)
        format_value_from_options(value, options)
      else
        autoformat_value(value, options)
      end
    end

    def format_value_from_options(value, options={})
      case options[:format]
      when :currency
        number_to_currency(value)
      when :tags
        tags = Array(value).map { |t| tag.span(t, class: "tag tag-primary") }
        tag.div(safe_join(tags), class: "tag-list")
      else
        value
      end
    end

    def autoformat_value(value, options={})
      case value
      when Array
        tag.ol(safe_join(value.map { |v|
          tag.li(v.is_a?(Array) ? v : autoformat_value(v, options)) },
        "\n"))
      when Time, DateTime
        timestamp(value)
      when Date
        datestamp(value)
      when TrueClass, FalseClass
        status_tag(icon("fa fa-check"), :success) if value
      when NilClass
        blank = options.key?(:blank) ? options[:blank] : I18n.t("admin.format.blank")
        if blank.respond_to?(:call)
          instance_exec(&blank)
        else
          tag.span(blank, class: "blank")
        end
      when String
        if value.html_safe? || options[:truncate] == false
          value
        else
          truncate(value, options[:truncate] || {})
        end
      when ->(value) { value.respond_to?(:id) }
        display(value)
      else
        value
      end
    end
  end
end
