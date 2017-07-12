module Trestle
  class Form
    module Fields
      class TagSelect < Select
        def initialize(builder, template, name, html_options={})
          choices = builder.object.send(name)
          super(builder, template, name, choices, {}, html_options)
        end

        def default_html_options
          super.merge(multiple: true, class: "tag-select", data: { tags: true, select_on_close: true })
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:tag_select, Trestle::Form::Fields::TagSelect)
