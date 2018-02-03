module Trestle
  class Form
    module Fields
      class TagSelect < Select
        def initialize(builder, template, name, options={}, html_options={})
          super(builder, template, name, nil, options, html_options)
        end

        def default_html_options
          super.merge(multiple: true, class: "tag-select", data: { tags: true })
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:tag_select, Trestle::Form::Fields::TagSelect)
