module Trestle
  class Form
    module Fields
      class RangeField < Field
        def field
          builder.raw_range_field(name, options)
        end

        def custom?
          options[:custom] != false
        end

        def normalize_options!
          options.reverse_merge!(class: ["custom-range"]) if custom?

          super
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:range_field, Trestle::Form::Fields::RangeField)
