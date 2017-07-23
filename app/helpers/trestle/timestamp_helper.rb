module Trestle
  module TimestampHelper
    def timestamp(time)
      time_tag(time, class: "timestamp") do
        safe_join([
          l(time, format: :trestle_date, default: proc { |date| "#{date.day.ordinalize} %b %Y" }),
          content_tag(:small, l(time, format: :trestle_time_with_seconds, default: "%l:%M:%S %p"))
        ], "\n")
      end
    end

    def datestamp(date)
      time_tag(date, class: "datestamp") do
        l(date, format: :trestle_calendar, default: "%-m/%-d/%Y")
      end
    end
  end
end
