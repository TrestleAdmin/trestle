module Trestle
  module FormatHelper
    # Formats a value, either with an explicit format (given the :format option)
    # or automatically based on its type using the `autoformat_value` helper.
    #
    # This helper is most commonly called when rendering content within a
    # table cell, but is available to use from any view context.
    #
    # value   - Value to format
    # format  - Symbol representing format type. Currently supported:
    #           :auto, nil - Auto-formats (default)
    #           :currency - Formats as currency using `number_to_currency`
    #           :tags - Formats an array of Strings as a tag list
    # options - Options hash to pass to `autoformat_value` helper
    #
    # Examples
    #
    #   <%= format_value(123.45, format: :currency) %>
    #   <%= format_value(article.tags, format: :tags) %>
    #
    #   <%= format_value(Time.current) %>
    #   <%= format_value(nil, blank: "None") %>
    #   <%= format_value(true) %>
    #
    # Returns a HTML-safe String.
    # Raises ArgumentError if an invalid format is given.
    def format_value(value, format: :auto, **options)
      case format
      when :auto, nil
        autoformat_value(value, **options)
      when :currency
        number_to_currency(value)
      when :tags
        tags = Array(value).map { |t| tag.span(t, class: "tag tag-primary") }
        tag.div(safe_join(tags), class: "tag-list")
      else
        raise ArgumentError, "unknown format: #{format}"
      end
    end

    # Auto-formats a value based on its type.
    #
    # The current implementation of this helper supports Arrays, Time/Datetime,
    # Date, true/false values, nil, String (with optional truncation) or model
    # instance types (using the `display` helper).
    #
    # value   - Value to format (multiple types supported)
    # options - Options hash, usage dependent on value type. Currently supported:
    #           :blank    - text to display for nil values (e.g. "N/A")
    #           :truncate - passed to truncate helper for String values
    #
    # Returns a HTML-safe String.
    def autoformat_value(value, **options)
      case value
      when Array
        tag.ol(safe_join(value.map { |v|
          tag.li(v.is_a?(Array) ? v : autoformat_value(v, **options)) },
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
