class Trestle::Form::Fields::TelephoneField < Trestle::Form::Fields::FormControl
  def field
    builder.raw_telephone_field(name, options)
  end
end

Trestle::Form::Builder.register(:telephone_field, Trestle::Form::Fields::TelephoneField)
Trestle::Form::Builder.register(:phone_field, Trestle::Form::Fields::TelephoneField)
