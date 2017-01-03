module Trestle
  class Form
    module Fields
      class DatetimeSelect < Field
        attr_reader :html_options

        def initialize(builder, template, name, options={}, html_options={}, &block)
          super(builder, template, name, options, &block)
          @html_options = html_options
          html_options[:class] ||= "form-control"
        end

        def field
          content_tag(:div, class: "datetime-select") do
            builder.raw_datetime_select(name, options, html_options, &block)
          end
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:datetime_select, Trestle::Form::Fields::DatetimeSelect)
