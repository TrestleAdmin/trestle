module Trestle::Form::Fields::DatePicker
  def extract_options!
    options[:prepend] ||= options.delete(:icon) { default_icon }
    options.reverse_merge!(data: { picker: options.delete(:picker) { true }, allow_clear: true })

    super
  end

  def default_icon
    icon("fa fa-calendar")
  end
end
