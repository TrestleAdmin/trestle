module Trestle
  class Form
    module Fields
      class FormGroup < Field
        def render
          classes = ['form-group']
          classes << 'has-error' if errors.any?

          content_tag(:div, options.slice(:data).merge(class: classes.compact)) do
            concat label unless options[:label] == false
            concat block.call if block
            concat help_message if options[:help]
            concat error_message if errors.any?
          end
        end

        def help_message
          content_tag(:p, options[:help], class: "help-block")
        end

        def error_message
          content_tag(:p, class: "help-block") do
            safe_join([icon("fa fa-warning"), errors.first], " ")
          end
        end

        def label
          builder.label(name, options[:label], class: ["control-label", ("sr-only" if options[:hide_label])])
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:form_group, Trestle::Form::Fields::FormGroup)
