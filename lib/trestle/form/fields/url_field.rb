Trestle::Form::Fields::UrlField = Trestle::Form::Fields::FormControl.build do
  builder.raw_url_field(name, options)
end

Trestle::Form::Builder.register(:url_field, Trestle::Form::Fields::UrlField)
