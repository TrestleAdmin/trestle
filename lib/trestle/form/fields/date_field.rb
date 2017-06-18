class Trestle::Form::Fields::DateField < Trestle::Form::Fields::FormControl
  include Trestle::Form::Fields::DatePicker

  def field
    builder.raw_date_field(name, options)
  end
end

Trestle::Form::Builder.register(:date_field, Trestle::Form::Fields::DateField)
