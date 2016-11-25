module Trestle
  class Form
    class Field
      attr_reader :builder, :template, :name, :options
      delegate :content_tag, :safe_join, :icon, to: :template

      def initialize(builder, template, name, options={})
        @builder, @template, @name, @options = builder, template, name, options
      end

      def errors
        builder.object.errors[name]
      end

      def error_message
        return if errors.none?

        content_tag(:p, class: "help-block") do
          safe_join([icon("fa fa-warning"), errors.first], " ")
        end
      end

      def form_group(classes)
        content_tag(:div, class: ["form-group", *classes].compact) do
          yield
        end
      end

      def render
        form_group(("has-error" if errors.any?)) do
          yield
        end
      end
    end

    module FormControl
      def initialize(*args)
        super(*args)
        options[:class] ||= "form-control"
      end
    end

    module LabelledField
      def render
        super do
          builder.label(name, options[:label]) + yield + error_message
        end
      end
    end

    class TextArea < Field
      include LabelledField
      include FormControl

      def render
        super do
          builder.original_text_area(name, options)
        end
      end
    end

    class TextField < Field
      include LabelledField
      include FormControl

      def render
        super do
          builder.original_text_field(name, options)
        end
      end
    end

    class PasswordField < Field
      include LabelledField
      include FormControl

      def render
        super do
          builder.original_password_field(name, options)
        end
      end
    end

    class Builder < ActionView::Helpers::FormBuilder
      (field_helpers - [:fields_for, :label]).each do |helper|
        alias_method :"original_#{helper}", helper
        undef_method helper
      end

      def self.fields
        @fields ||= {}
      end

      def self.register(name, klass)
        self.fields[name] = klass
      end

      def respond_to?(name, include_all=false)
        super || self.class.fields.has_key?(name)
      end

    protected
      def method_missing(name, *args, &block)
        if field = self.class.fields[name]
          field.new(self, @template, *args, &block).render
        else
          super
        end
      end
    end

    Builder.register(:text_field, TextField)
    Builder.register(:password_field, PasswordField)
    Builder.register(:text_area, TextArea)
  end
end
