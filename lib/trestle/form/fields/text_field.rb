Trestle::Form::Fields::TextField = Trestle::Form::Fields::FormControl.build do
  builder.raw_text_field(name, options)
end

Trestle::Form::Builder.register(:text_field, Trestle::Form::Fields::TextField)
