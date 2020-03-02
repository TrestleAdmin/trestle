module Trestle
  class Form
    module Fields
      require_relative "fields/form_control"
      require_relative "fields/form_group"

      require_relative "fields/date_picker"

      require_relative "fields/check_box_helpers"
      require_relative "fields/radio_button_helpers"

      Dir.glob("#{__dir__}/fields/*.rb") { |f| require_relative f }
    end
  end
end
