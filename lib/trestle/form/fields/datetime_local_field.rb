Trestle::Form::Fields::DatetimeLocalField = Trestle::Form::Fields::FormControl.build do
  builder.raw_datetime_local_field(name, options)
end

Trestle::Form::Builder.register(:datetime_local_field, Trestle::Form::Fields::DatetimeLocalField)
