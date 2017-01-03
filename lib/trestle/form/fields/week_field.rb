Trestle::Form::Fields::WeekField = Trestle::Form::Fields::FormControl.build do
  builder.raw_week_field(name, options)
end

Trestle::Form::Builder.register(:week_field, Trestle::Form::Fields::WeekField)
