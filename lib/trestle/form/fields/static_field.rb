module Trestle
  class Form
    module Fields
      class StaticField < Field
        attr_reader :value
        
        def initialize(builder, template, name, value, options={})
          super(builder, template, name, options)
          @value = value
        end

        def field
          content_tag(:p, value, class: "form-control-static")
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:static_field, Trestle::Form::Fields::StaticField)
