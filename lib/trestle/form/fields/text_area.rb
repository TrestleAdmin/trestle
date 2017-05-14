class Trestle::Form::Fields::TextArea < Trestle::Form::Fields::FormControl
  def defaults
    super.merge(rows: 5)
  end

  def field
    builder.raw_text_area(name, options)
  end
end

Trestle::Form::Builder.register(:text_area, Trestle::Form::Fields::TextArea)
