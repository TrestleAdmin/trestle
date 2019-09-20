module Trestle
  class Form
    module Fields
      class CollectionRadioButtons < Field
        include RadioButtonHelpers

        attr_reader :collection, :value_method, :text_method, :html_options

        def initialize(builder, template, name, collection, value_method, text_method, options={}, html_options={}, &block)
          super(builder, template, name, options, &block)

          @collection, @value_method, @text_method = collection, value_method, text_method
          @html_options = default_html_options.merge(html_options)
        end

        def field
          builder.raw_collection_radio_buttons(name, collection, value_method, text_method, options, html_options) do |b|
            if block
              block.call(b)
            else
              content_tag(:div, class: default_wrapper_class) do
                b.radio_button(class: input_class) + b.label(class: label_class) { b.text }
              end
            end
          end
        end

        def defaults
          super.merge(inline: true)
        end

        def default_html_options
          Trestle::Options.new
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:collection_radio_buttons, Trestle::Form::Fields::CollectionRadioButtons)
