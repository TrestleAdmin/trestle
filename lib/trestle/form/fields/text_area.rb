class Trestle::Form::Fields::TextArea < Trestle::Form::Fields::FormControl
  def field
    builder.raw_text_area(name, options)
  end
end

Trestle::Form::Builder.register(:text_area, Trestle::Form::Fields::TextArea)
