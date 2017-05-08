module Trestle
  class Form
    module Fields
      class FormControl < Field
        def initialize(*args)
          super(*args)
        end

        def render
          form_group do
            input_group do
              field
            end
          end
        end

        def input_group
          if options[:prepend] || options[:append]
            content_tag(:div, class: "input-group") do
              concat content_tag(:span, options[:prepend], class: "input-group-addon") if options[:prepend]
              concat yield
              concat content_tag(:span, options[:append], class: "input-group-addon") if options[:append]
            end
          else
            yield
          end
        end

        def self.build(&block)
          Class.new(self) do
            define_method(:field, &block)
          end
        end

        def defaults
          super.merge(class: ["form-control"])
        end
      end
    end
  end
end
