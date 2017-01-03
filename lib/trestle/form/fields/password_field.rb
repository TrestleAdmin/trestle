Trestle::Form::Fields::PasswordField = Trestle::Form::Fields::FormControl.build do
  builder.raw_password_field(name, options)
end

Trestle::Form::Builder.register(:password_field, Trestle::Form::Fields::PasswordField)
