module Trestle
  class Form
    module Fields
      module CheckBoxHelpers
        def switch?
          options[:switch]
        end

        def inline?
          options[:inline]
        end

        def default_wrapper_class
          [
            "form-check",
            ("form-switch" if switch?),
            ("form-check-inline" if inline?)
          ].compact
        end

        def input_class
          ["form-check-input"]
        end

        def label_class
          ["form-check-label"]
        end

        def defaults
          Trestle::Options.new(disabled: readonly?)
        end
      end
    end
  end
end
