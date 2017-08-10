module Trestle
  class Form
    module Fields
      class GroupedCollectionSelect < Field
        attr_reader :collection, :group_method, :group_label_method, :option_key_method, :option_value_method, :html_options

        def initialize(builder, template, name, collection, group_method, group_label_method, option_key_method, option_value_method, options={}, html_options={})
          super(builder, template, name, options)

          @collection, @group_method, @group_label_method, @option_key_method, @option_value_method = collection, group_method, group_label_method, option_key_method, option_value_method
          @html_options = default_html_options.merge(html_options)
        end

        def field
          builder.raw_grouped_collection_select(name, collection, group_method, group_label_method, option_key_method, option_value_method, options, html_options)
        end

        def default_html_options
          Trestle::Options.new(class: ["form-control"], data: { enable_select2: true })
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:grouped_collection_select, Trestle::Form::Fields::GroupedCollectionSelect)
