class Trestle::Form::Fields::WeekField < Trestle::Form::Fields::FormControl
  def field
    builder.raw_week_field(name, options)
  end
end

Trestle::Form::Builder.register(:week_field, Trestle::Form::Fields::WeekField)
