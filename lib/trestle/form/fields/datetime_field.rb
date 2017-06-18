class Trestle::Form::Fields::DatetimeField < Trestle::Form::Fields::FormControl
  include Trestle::Form::Fields::DatePicker

  def field
    builder.raw_datetime_field(name, options)
  end
end

Trestle::Form::Builder.register(:datetime_field, Trestle::Form::Fields::DatetimeField)
Trestle::Form::Builder.register(:datetime_local_field, Trestle::Form::Fields::DatetimeField)
