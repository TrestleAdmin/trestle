{
  'zh-CN' => {
    date: {
      formats: {
        trestle_date: proc { |date| "%Y年%-m月%-d日" },
        trestle_calendar: "%Y年%-m月%-d日"
      }
    },

    time: {
      formats: {
        trestle_date: proc { |time| "%Y年%-m月%-d日" },
        trestle_time: "%H:%M",
        trestle_time_with_seconds: "%H:%M:%S"
      }
    }
  }
}
