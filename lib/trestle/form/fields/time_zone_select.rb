module Trestle
  class Form
    module Fields
      class TimeZoneSelect < Field
        attr_reader :priority_zones, :html_options

        def initialize(builder, template, name, priority_zones=nil, options={}, html_options={}, &block)
          super(builder, template, name, options, &block)

          @priority_zones = priority_zones
          @html_options = default_html_options.merge(html_options)
        end

        def field
          builder.raw_time_zone_select(name, priority_zones, options, html_options, &block)
        end

        def default_html_options
          Trestle::Options.new(class: ["form-control"], data: { enable_select2: true })
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:time_zone_select, Trestle::Form::Fields::TimeZoneSelect)
