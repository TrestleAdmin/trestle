module Trestle
  module TimestampHelper
    # Renders a Time object as a formatted timestamp (using a <time> tag)
    #
    # time    - The Time object to format.
    # options - Hash of options (default: {}):
    #           :class       - Additional HTML classes to add to the <time> tag.
    #           :precision   - Time precision, either :minutes or :seconds (default: :minutes).
    #           :date_format - I18n date format to use for the date (default: :trestle_date).
    #           :time_format - I18n time format to use for the time (default: :trestle_time).
    #
    # Examples
    #
    #   <%= timestamp(article.created_at) %>
    #
    #   <%= timestamp(Time.current, class: "timestamp-inline", precision: :seconds) %>
    #
    # Returns the HTML representation of the given Time.
    def timestamp(time, options={})
      return unless time

      classes     = ["timestamp", options[:class]].compact
      precision   = options.fetch(:precision) { Trestle.config.timestamp_precision }
      date_format = options.fetch(:date_format) { :trestle_date }
      time_format = options.fetch(:time_format) { precision == :seconds ? :trestle_time_with_seconds : :trestle_time }

      time_tag(time, class: classes) do
        safe_join([
          l(time, format: date_format, default: proc { |date| "#{date.day.ordinalize} %b %Y" }),
          content_tag(:small, l(time, format: time_format, default: "%l:%M:%S %p"))
        ], "\n")
      end
    end

    # Renders a Date object as formatted datestamp (using a <time> tag)
    #
    # date    - The Date object to format.
    # options - Hash of options (default: {}):
    #           :class  - Additional HTML classes to add to the <time> tag.
    #           :format - I18n date format to use (default: :trestle_calendar).
    #
    # Examples
    #
    #   <%= datestamp(Date.current) %>
    #
    #   <%= datestamp(article.created_at, format: :trestle_date, class: "custom-datestamp") %>
    #
    # Returns the HTML representation of the given Date.
    def datestamp(date, options={})
      return unless date

      classes = ["datestamp", options[:class]].compact
      format  = options.fetch(:format) { :trestle_calendar}

      time_tag(date, class: classes) do
        l(date, format: format, default: "%-m/%-d/%Y")
      end
    end
  end
end
