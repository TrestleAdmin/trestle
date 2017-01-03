Trestle::Form::Fields::NumberField = Trestle::Form::Fields::FormControl.build do
  builder.raw_number_field(name, options)
end

Trestle::Form::Builder.register(:number_field, Trestle::Form::Fields::NumberField)
