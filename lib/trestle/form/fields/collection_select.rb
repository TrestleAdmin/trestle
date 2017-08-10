module Trestle
  class Form
    module Fields
      class CollectionSelect < Field
        attr_reader :collection, :value_method, :text_method, :html_options

        def initialize(builder, template, name, collection, value_method, text_method, options={}, html_options={})
          super(builder, template, name, options)

          @collection, @value_method, @text_method = collection, value_method, text_method
          @html_options = default_html_options.merge(html_options)
        end

        def field
          builder.raw_collection_select(name, collection, value_method, text_method, options, html_options)
        end

        def default_html_options
          Trestle::Options.new(class: ["form-control"], data: { enable_select2: true })
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:collection_select, Trestle::Form::Fields::CollectionSelect)
