module Trestle::Form::Fields::DatePicker
  def normalize_options!
    unless options[:prepend] == false
      options[:prepend] ||= options.delete(:icon) { default_icon }
    end

    super
  end

  def defaults
    defaults = super
    defaults.merge!(data: { controller: controller, allow_clear: true }) if enable_date_picker?
    defaults
  end

  def default_icon
    icon("fa fa-calendar")
  end

  def enable_date_picker?
    !disabled? && !readonly? && options[:picker] != false
  end

  def controller
    "datepicker"
  end
end
