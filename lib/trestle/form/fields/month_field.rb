class Trestle::Form::Fields::MonthField < Trestle::Form::Fields::FormControl
  def field
    builder.raw_month_field(name, options)
  end
end

Trestle::Form::Builder.register(:month_field, Trestle::Form::Fields::MonthField)
