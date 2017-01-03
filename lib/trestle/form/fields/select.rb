module Trestle
  class Form
    module Fields
      class Select < Field
        attr_reader :choices, :html_options

        def initialize(builder, template, name, choices=nil, options={}, html_options={}, &block)
          super(builder, template, name, options, &block)
          @choices, @html_options = choices, html_options
          html_options[:class] ||= "form-control"
        end

        def field
          builder.raw_select(name, choices, options, html_options, &block)
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:select, Trestle::Form::Fields::Select)
