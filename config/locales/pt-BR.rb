{
  'pt-BR': {
    date: {
      formats: {
        trestle_date: proc { |date| "#{date.day}º %b %Y" },
        trestle_calendar: "%-m/%-d/%Y"
      }
    },

    time: {
      formats: {
        trestle_date: proc { |time| "#{time.day}º %b %Y" },
        trestle_time: "%-l:%M %p",
        trestle_time_with_seconds: "%l:%M:%S %p"
      }
    }
  }
}
