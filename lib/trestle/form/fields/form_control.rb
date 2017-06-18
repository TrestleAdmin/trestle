module Trestle
  class Form
    module Fields
      class FormControl < Field
        def render
          form_group do
            input_group do
              field
            end
          end
        end

        def input_group
          if @prepend || @append
            content_tag(:div, class: "input-group") do
              concat content_tag(:span, @prepend, class: "input-group-addon") if @prepend
              concat yield
              concat content_tag(:span, @append, class: "input-group-addon") if @append
            end
          else
            yield
          end
        end

        def defaults
          super.merge(class: ["form-control"])
        end

        def extract_options!
          super

          @prepend = options.delete(:prepend)
          @append  = options.delete(:append)
        end
      end
    end
  end
end
