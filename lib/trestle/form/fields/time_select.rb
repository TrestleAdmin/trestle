module Trestle
  class Form
    module Fields
      class TimeSelect < Field
        attr_reader :html_options

        def initialize(builder, template, name, options={}, html_options={}, &block)
          super(builder, template, name, options, &block)

          @html_options = default_html_options.merge(html_options)
        end

        def field
          tag.div(class: "time-select") do
            builder.raw_time_select(name, options, html_options, &block)
          end
        end

        def default_html_options
          Trestle::Options.new(class: ["form-select"], disabled: readonly?, data: { controller: "select" })
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:time_select, Trestle::Form::Fields::TimeSelect)
