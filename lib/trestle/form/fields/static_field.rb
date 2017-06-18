module Trestle
  class Form
    module Fields
      class StaticField < Field
        attr_reader :value

        def initialize(builder, template, name, value=nil, options={}, &block)
          if block_given? && value.is_a?(Hash)
            options = value
          else
            @value = value
          end

          super(builder, template, name, options, &block)
        end

        def field
          if block
            template.capture(&block)
          else
            content_tag(:p, value, class: "form-control-static")
          end
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:static_field, Trestle::Form::Fields::StaticField)
