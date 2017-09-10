{
  nl: {
    date: {
      formats: {
        trestle_date: proc { |date| "#{date.day} %b %Y" },
        trestle_calendar: "%-d-%-m-%Y"
      }
    },

    time: {
      formats: {
        trestle_date: proc { |time| "#{time.day} %b %Y" },
        trestle_time: "%R %p",
        trestle_time_with_seconds: "%T %p"
      }
    }
  }
}
