Trestle::Form::Fields::TextArea = Trestle::Form::Fields::FormControl.build do
  builder.raw_text_area(name, options)
end

Trestle::Form::Builder.register(:text_area, Trestle::Form::Fields::TextArea)
