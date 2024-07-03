class Trestle::Form::Fields::FileField < Trestle::Form::Fields::FormControl
  def field
    builder.raw_file_field(name, options)
  end
end

Trestle::Form::Builder.register(:file_field, Trestle::Form::Fields::FileField)
