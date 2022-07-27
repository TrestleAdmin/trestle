class CustomField < Trestle::Form::Field
  def initialize(builder, template, name, options={}, &block)
    super(builder, template, name, options, &block)
  end

  def field
    content_tag(:div, "Custom Field", class: "p-2 text-white bg-info font-weight-bold")
  end
end
