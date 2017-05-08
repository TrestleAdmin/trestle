class Trestle::Form::Fields::TextField < Trestle::Form::Fields::FormControl
  def field
    builder.raw_text_field(name, options)
  end
end

Trestle::Form::Builder.register(:text_field, Trestle::Form::Fields::TextField)
