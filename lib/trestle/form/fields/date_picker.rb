module Trestle::Form::Fields::DatePicker
  def normalize_options!
    options[:prepend] ||= options.delete(:icon) { default_icon }
    options.reverse_merge!(data: { picker: true, allow_clear: true }) if enable_date_picker?

    super
  end

  def default_icon
    icon("fa fa-calendar")
  end

  def enable_date_picker?
    !disabled? && !readonly? && options[:picker] != false
  end
end
