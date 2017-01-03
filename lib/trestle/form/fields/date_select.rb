module Trestle
  class Form
    module Fields
      class DateSelect < Field
        attr_reader :html_options

        def initialize(builder, template, name, options={}, html_options={}, &block)
          super(builder, template, name, options, &block)
          @html_options = html_options
          html_options[:class] ||= "form-control"
        end

        def field
          content_tag(:div, class: "date-select") do
            builder.raw_date_select(name, options, html_options, &block)
          end
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:date_select, Trestle::Form::Fields::DateSelect)
