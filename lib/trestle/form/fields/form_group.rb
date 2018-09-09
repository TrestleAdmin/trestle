module Trestle
  class Form
    module Fields
      class FormGroup < Field
        WRAPPER_OPTIONS = [:help, :label, :hide_label]

        def render
          options[:class] << 'has-error' if errors.any?

          content_tag(:div, options.except(*WRAPPER_OPTIONS)) do
            concat label unless options[:label] == false
            concat template.capture(&block) if block
            concat help_message if options[:help]
            concat error_message if errors.any?
          end
        end

        def help_message
          classes = ["help-block"]

          if options[:help].is_a?(Hash)
            message = options[:help][:text]
            classes << "floating" if options[:help][:float]
          else
            message = options[:help]
          end

          content_tag(:p, message, class: classes)
        end

        def error_message
          content_tag(:p, class: "help-block") do
            safe_join([icon("fa fa-warning"), errors.first], " ")
          end
        end

        def label
          builder.label(name, options[:label], class: ["control-label", ("sr-only" if options[:hide_label])].compact)
        end

        def defaults
          super.merge(class: ["form-group"])
        end

        def extract_options!
          # Do not call super
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:form_group, Trestle::Form::Fields::FormGroup)
