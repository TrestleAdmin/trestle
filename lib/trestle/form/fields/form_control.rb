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
              concat content_tag(:div, input_group_addon(@prepend), class: "input-group-prepend") if @prepend
              concat yield
              concat content_tag(:div, input_group_addon(@append), class: "input-group-append") if @append
            end
          else
            yield
          end
        end

        def input_group_addon(addon)
          if addon[:wrap]
            content_tag(:span, addon[:content], class: "input-group-text")
          else
            addon[:content]
          end
        end

        def defaults
          super.merge(class: ["form-control"])
        end

        def normalize_options!
          super

          @prepend = { content: options.delete(:prepend),  wrap: true }  if options[:prepend]
          @prepend = { content: options.delete(:prepend!), wrap: false } if options[:prepend!]
          @append  = { content: options.delete(:append),   wrap: true }  if options[:append]
          @append  = { content: options.delete(:append!),  wrap: false } if options[:append!]
        end
      end
    end
  end
end
