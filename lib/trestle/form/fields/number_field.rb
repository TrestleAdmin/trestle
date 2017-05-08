class Trestle::Form::Fields::NumberField < Trestle::Form::Fields::FormControl
  def field
    builder.raw_number_field(name, options)
  end
end

Trestle::Form::Builder.register(:number_field, Trestle::Form::Fields::NumberField)
