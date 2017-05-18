module Trestle
  class Form
    module Fields
      class CollectionCheckBoxes < Field
        attr_reader :collection, :value_method, :text_method, :html_options

        def initialize(builder, template, name, collection, value_method, text_method, options={}, html_options={})
          super(builder, template, name, options)

          @collection, @value_method, @text_method = collection, value_method, text_method
          @html_options = default_html_options.merge(html_options)
        end

        def field
          content_tag(:div, class: "checkboxes") do
            builder.raw_collection_check_boxes(name, collection, value_method, text_method, options, html_options) do |b|
              b.label(class: "checkbox-inline") { b.check_box + b.text }
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

Trestle::Form::Builder.register(:collection_check_boxes, Trestle::Form::Fields::CollectionCheckBoxes)
