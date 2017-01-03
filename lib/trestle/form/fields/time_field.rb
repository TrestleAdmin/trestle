Trestle::Form::Fields::TimeField = Trestle::Form::Fields::FormControl.build do
  builder.raw_time_field(name, options)
end

Trestle::Form::Builder.register(:time_field, Trestle::Form::Fields::TimeField)
