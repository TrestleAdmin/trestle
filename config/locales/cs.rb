{
  cs: {
    date: {
      formats: {
        trestle_date: proc { |date| "%d/%m/%Y" },
        trestle_calendar: "%d/%m/%Y"
      }
    },

    time: {
      formats: {
        trestle_date: proc { |time| "%d/%m/%Y" },
        trestle_time: "%H:%M",
        trestle_time_with_seconds: "%H:%M:%S"
      }
    }
  }
}
