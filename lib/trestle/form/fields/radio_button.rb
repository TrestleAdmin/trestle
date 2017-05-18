module Trestle
  class Form
    module Fields
      class RadioButton < Field
        attr_reader :tag_value

        def initialize(builder, template, name, tag_value, options={})
          super(builder, template, name, options)

          @tag_value = tag_value
        end

        def render
          field
        end

        def field
          content_tag(:div, class: "radio") do
            content_tag(:label) do
              safe_join([
                builder.raw_radio_button(name, tag_value, options),
                options[:label] || tag_value.to_s.humanize
              ], " ")
            end
          end
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:radio_button, Trestle::Form::Fields::RadioButton)
