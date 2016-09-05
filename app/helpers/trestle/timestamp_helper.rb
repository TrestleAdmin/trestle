module Trestle
  module TimestampHelper
    def timestamp(time)
      time_tag(time, class: "timestamp") do
        safe_join([
          l(time, format: :trestle_date),
          content_tag(:small, l(time, format: :trestle_time_with_seconds))
        ], "\n")
      end
    end

    def datestamp(date)
      time_tag(date, class: "datestamp") do
        l(date, format: :trestle_calendar)
      end
    end
  end
end
