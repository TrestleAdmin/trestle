Trestle::Form::Fields::EmailField = Trestle::Form::Fields::FormControl.build do
  builder.raw_email_field(name, options)
end

Trestle::Form::Builder.register(:email_field, Trestle::Form::Fields::EmailField)
