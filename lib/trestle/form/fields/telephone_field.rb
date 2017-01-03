Trestle::Form::Fields::TelephoneField = Trestle::Form::Fields::FormControl.build do
  builder.raw_telephone_field(name, options)
end

Trestle::Form::Builder.register(:telephone_field, Trestle::Form::Fields::TelephoneField)
Trestle::Form::Builder.register(:phone_field, Trestle::Form::Fields::TelephoneField)
