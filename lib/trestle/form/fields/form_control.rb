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
              concat input_group_addon(@prepend) if @prepend
              concat yield
              concat input_group_addon(@append) if @append
            end
          else
            yield
          end
        end

        def input_group_addon(addon)
          if addon[:wrap]
            content_tag(:span, addon[:content], class: "input-group-addon")
          else
            addon[:content]
          end
        end

        def defaults
          super.merge(class: ["form-control"])
        end

        def extract_options!
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
