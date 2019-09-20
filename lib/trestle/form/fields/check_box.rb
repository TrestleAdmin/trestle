module Trestle
  class Form
    module Fields
      class CheckBox < Field
        include CheckBoxHelpers

        attr_reader :checked_value, :unchecked_value

        def initialize(builder, template, name, options = {}, checked_value = "1", unchecked_value = "0")
          super(builder, template, name, options)
          @checked_value, @unchecked_value = checked_value, unchecked_value
        end

        def render
          field
        end

        def field
          wrapper_class = options.delete(:class)
          wrapper_class = default_wrapper_class if wrapper_class.empty?

          content_tag(:div, class: wrapper_class) do
            safe_join([
              builder.raw_check_box(name, options.merge(class: input_class), checked_value, unchecked_value),
              builder.label(name, options[:label] || admin.human_attribute_name(name), class: label_class, value: (checked_value if options[:multiple]))
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

Trestle::Form::Builder.register(:check_box, Trestle::Form::Fields::CheckBox)
