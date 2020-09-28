module Trestle
  class Form
    module Fields
      class StaticField < Field
        attr_reader :value

        def initialize(builder, template, name, value=nil, options={}, &block)
          if value.is_a?(Hash)
            @value, options = nil, value
          else
            @value = value
          end

          super(builder, template, name, options, &block)
        end

        def field
          if block
            template.capture(&block)
          else
            content_tag(:p, value || default_value, class: "form-control-static")
          end
        end

        def default_value
          builder.object.send(name) if builder.object
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:static_field, Trestle::Form::Fields::StaticField)
