module Trestle
  class Form
    module Fields
      class FormGroup < Field
        WRAPPER_OPTIONS = [:help, :label, :hide_label]

        def initialize(builder, template, name=nil, options={}, &block)
          # Normalize options passed as name parameter
          name, options = nil, name if name.is_a?(Hash)

          super(builder, template, name, options, &block)
        end

        def render
          content_tag(:div, options.except(*WRAPPER_OPTIONS)) do
            concat label if name && options[:label] != false
            concat template.capture(&block) if block
            concat help_message if options[:help]
            concat error_messages if name && errors.any?
          end
        end

        def help_message
          classes = ["form-text"]

          if options[:help].is_a?(Hash)
            message = options[:help][:text]
            classes << "floating" if options[:help][:float]
          else
            message = options[:help]
          end

          content_tag(:p, message, class: classes)
        end

        def error_messages
          content_tag(:ul, class: "invalid-feedback") do
            safe_join(errors.map { |error|
              content_tag(:li, safe_join([icon("fa fa-warning"), error], " "))
            }, "\n")
          end
        end

        def label
          builder.label(name, options[:label], class: ["control-label", ("sr-only" if options[:hide_label])].compact)
        end

        def defaults
          Trestle::Options.new(class: ["form-group"])
        end

      protected
        def extract_wrapper_options!
          # Intentional no-op
        end

        def error_class
          "has-error"
        end

        def error_keys
          name ? super : []
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:form_group, Trestle::Form::Fields::FormGroup)
