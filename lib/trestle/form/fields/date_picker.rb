module Trestle::Form::Fields::DatePicker
  def extract_options!
    options[:prepend] ||= options.key?(:icon) ? options.delete(:icon) : default_icon
    options.deep_merge!(data: { picker: options.fetch(:picker, true })

    super
  end

  def default_icon
    icon("fa fa-calendar")
  end
end
