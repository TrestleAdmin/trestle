Trestle::Form::Fields::DateField = Trestle::Form::Fields::FormControl.build do
  builder.raw_date_field(name, options)
end

Trestle::Form::Builder.register(:date_field, Trestle::Form::Fields::DateField)
