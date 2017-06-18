module Trestle::Form::Fields::DatePicker
  def extract_options!
    options[:prepend] ||= options.key?(:icon) ? options.delete(:icon) : default_icon
    options.merge!(data: { picker: options.key?(:picker) ? options.delete(:picker) : true })

    super
  end

  def default_icon
    icon("fa fa-calendar")
  end
end
