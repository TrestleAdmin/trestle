module Trestle
  class Form
    module Fields
      module RadioButtonHelpers
        def inline?
          options[:inline]
        end

        def default_wrapper_class
          [
            "form-check",
            ("form-check-inline" if inline?)
          ].compact
        end

        def input_class
          ["form-check-input"]
        end

        def label_class
          ["form-check-label"]
        end
      end
    end
  end
end
