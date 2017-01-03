Trestle::Form::Fields::DatetimeField = Trestle::Form::Fields::FormControl.build do
  builder.raw_datetime_field(name, options)
end

Trestle::Form::Builder.register(:datetime_field, Trestle::Form::Fields::DatetimeField)
