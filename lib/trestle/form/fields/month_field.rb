Trestle::Form::Fields::MonthField = Trestle::Form::Fields::FormControl.build do
  builder.raw_month_field(name, options)
end

Trestle::Form::Builder.register(:month_field, Trestle::Form::Fields::MonthField)
