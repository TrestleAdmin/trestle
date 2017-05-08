class Trestle::Form::Fields::TimeField < Trestle::Form::Fields::FormControl
  def defaults
    super.merge(prepend: icon("fa fa-clock-o"))
  end

  def field
    builder.raw_time_field(name, options)
  end
end

Trestle::Form::Builder.register(:time_field, Trestle::Form::Fields::TimeField)
