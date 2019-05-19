module Trestle
  class Form
    module Fields
      class RadioButton < Field
        include RadioButtonHelpers

        attr_reader :tag_value

        def initialize(builder, template, name, tag_value, options={})
          super(builder, template, name, options)

          @tag_value = tag_value
        end

        def render
          field
        end

        def field
          wrapper_class = options.delete(:class)
          wrapper_class = default_wrapper_class if wrapper_class.empty?

          content_tag(:div, class: wrapper_class) do
            safe_join([
              builder.raw_radio_button(name, tag_value, options.merge(class: input_class)),
              builder.label(name, options[:label] || tag_value.to_s.humanize, value: tag_value, class: label_class)
            ])
          end
        end

        def extract_wrapper_options!
          # Intentional no-op
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:radio_button, Trestle::Form::Fields::RadioButton)
