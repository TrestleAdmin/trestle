module Trestle
  module TimestampHelper
    # Renders a Time object as a formatted timestamp (using a <time> tag).
    #
    # time        - The Time object to format
    # precision   - Time precision, either :minutes or :seconds (default: :minutes)
    # date_format - I18n date format to use for the date (default: :trestle_date)
    # time_format - I18n time format to use for the time (default: :trestle_time,
    #                 or :trestle_time_with_seconds if precision is :seconds)
    # attributes  - Additional HTML attributes to add to the <time> tag
    #
    # Examples
    #
    #   <%= timestamp(article.created_at) %>
    #
    #   <%= timestamp(Time.current, class: "timestamp-inline", precision: :seconds) %>
    #
    # Returns the HTML representation of the given Time.
    def timestamp(time, precision: Trestle.config.timestamp_precision, date_format: :trestle_date, time_format: nil, **attributes)
      return unless time

      time_format ||= (precision == :seconds) ? :trestle_time_with_seconds : :trestle_time

      time_tag(time, **attributes.merge(class: ["timestamp", attributes[:class]])) do
        safe_join([
          tag.span(l(time, format: date_format, default: proc { |date| "#{date.day.ordinalize} %b %Y" })),
          tag.small(l(time, format: time_format, default: "%l:%M:%S %p"))
        ], "\n")
      end
    end

    # Renders a Date object as formatted datestamp (using a <time> tag).
    #
    # date       - The Date object to format
    # format     - I18n date format to use (default: :trestle_calendar)
    # attributes - Additional HTML attributes to add to the <time> tag
    #
    # Examples
    #
    #   <%= datestamp(Date.current) %>
    #
    #   <%= datestamp(article.created_at, format: :trestle_date, class: "custom-datestamp") %>
    #
    # Returns the HTML representation of the given Date.
    def datestamp(date, format: :trestle_calendar, **attributes)
      return unless date

      time_tag(date, **attributes.merge(class: ["datestamp", attributes[:class]])) do
        l(date, format: format, default: "%-m/%-d/%Y")
      end
    end
  end
end
