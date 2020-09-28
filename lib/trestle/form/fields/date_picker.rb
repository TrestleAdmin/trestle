module Trestle::Form::Fields::DatePicker
  def normalize_options!
    unless options[:prepend] == false
      options[:prepend] ||= options.delete(:icon) { default_icon }
    end

    if enable_date_picker?
      options.reverse_merge!(data: { picker: true, allow_clear: true })
    end

    super
  end

  def default_icon
    icon("fa fa-calendar")
  end

  def enable_date_picker?
    !disabled? && !readonly? && options[:picker] != false
  end
end
