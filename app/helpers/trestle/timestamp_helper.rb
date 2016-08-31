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
  end
end
