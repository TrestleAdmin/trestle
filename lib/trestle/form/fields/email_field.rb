class Trestle::Form::Fields::EmailField < Trestle::Form::Fields::FormControl
  def field
    builder.raw_email_field(name, options)
  end
end

Trestle::Form::Builder.register(:email_field, Trestle::Form::Fields::EmailField)
