class Trestle::Form::Fields::UrlField < Trestle::Form::Fields::FormControl
  def field
    builder.raw_url_field(name, options)
  end
end

Trestle::Form::Builder.register(:url_field, Trestle::Form::Fields::UrlField)
