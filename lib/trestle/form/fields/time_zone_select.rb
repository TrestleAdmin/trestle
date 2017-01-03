module Trestle
  class Form
    module Fields
      class TimeZoneSelect < Field
        attr_reader :priority_zones, :html_options

        def initialize(builder, template, name, priority_zones=nil, options={}, html_options={}, &block)
          super(builder, template, name, options, &block)
          @priority_zones, @html_options = priority_zones, html_options
          html_options[:class] ||= "form-control"
        end

        def field
          builder.raw_time_zone_select(name, priority_zones, options, html_options, &block)
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:time_zone_select, Trestle::Form::Fields::TimeZoneSelect)
