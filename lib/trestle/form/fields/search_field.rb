Trestle::Form::Fields::SearchField = Trestle::Form::Fields::FormControl.build do
  builder.raw_search_field(name, options)
end

Trestle::Form::Builder.register(:search_field, Trestle::Form::Fields::SearchField)
