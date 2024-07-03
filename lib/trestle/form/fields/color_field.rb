class Trestle::Form::Fields::ColorField < Trestle::Form::Fields::FormControl
  def field
    builder.raw_color_field(name, options)
  end

  def defaults
    super.merge(class: ["form-control-color"])
  end
end

Trestle::Form::Builder.register(:color_field, Trestle::Form::Fields::ColorField)
