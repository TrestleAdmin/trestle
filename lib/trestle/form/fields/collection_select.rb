module Trestle
  class Form
    module Fields
      class CollectionSelect < Field
        attr_reader :collection, :value_method, :text_method, :html_options

        def initialize(builder, template, name, collection, value_method, text_method, options={}, html_options={})
          super(builder, template, name, options)
          @collection, @value_method, @text_method, @html_options = collection, value_method, text_method, html_options
          html_options[:class] ||= "form-control"
        end

        def field
          builder.raw_collection_select(name, collection, value_method, text_method, options, html_options)
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:collection_select, Trestle::Form::Fields::CollectionSelect)
