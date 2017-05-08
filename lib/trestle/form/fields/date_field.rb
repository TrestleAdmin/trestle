class Trestle::Form::Fields::DateField < Trestle::Form::Fields::FormControl
  def defaults
    super.merge(prepend: icon("fa fa-calendar"))
  end

  def field
    builder.raw_date_field(name, options)
  end
end

Trestle::Form::Builder.register(:date_field, Trestle::Form::Fields::DateField)
