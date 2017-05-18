module Trestle
  class Form
    module Fields
      class CollectionRadioButtons < Field
        attr_reader :collection, :value_method, :text_method, :html_options

        def initialize(builder, template, name, collection, value_method, text_method, options={}, html_options={})
          super(builder, template, name, options)

          @collection, @value_method, @text_method = collection, value_method, text_method
          @html_options = default_html_options.merge(html_options)
        end

        def field
          content_tag(:div, class: "radio-buttons") do
            builder.raw_collection_radio_buttons(name, collection, value_method, text_method, options, html_options) do |b|
              b.label(class: "radio-inline") { b.radio_button + b.text }
            end
          end
        end

        def default_html_options
          Trestle::Options.new
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:collection_radio_buttons, Trestle::Form::Fields::CollectionRadioButtons)
