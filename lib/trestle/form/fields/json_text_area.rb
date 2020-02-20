class Trestle::Form::Fields::JsonTextArea < Trestle::Form::Fields::FormControl
  def defaults
    super.merge(class: "json-text-area")
  end

  def field
    value = if builder.object
        builder.object.send(name)
      else
        {}
      end

    content_tag(:div, class: "json-text-area") do
      concat builder.hidden_field(name, options.merge(value: value.to_json))
      concat content_tag(:div, "", data: { enable_jsoneditor: true, value_field: name })
    end
  end
end

Trestle::Form::Builder.register(:json_text_area, Trestle::Form::Fields::JsonTextArea)
