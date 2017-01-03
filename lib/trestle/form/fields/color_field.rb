Trestle::Form::Fields::ColorField = Trestle::Form::Fields::FormControl.build do
  builder.raw_color_field(name, options)
end

Trestle::Form::Builder.register(:color_field, Trestle::Form::Fields::ColorField)
