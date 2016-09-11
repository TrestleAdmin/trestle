module Trestle
  class Form
    class Builder < ActionView::Helpers::FormBuilder
      def text_area(name, options={})
        labelled_field(name, options) do
          super(name, options)
        end
      end

      def text_field(name, options={})
        labelled_field(name, options) do
          super(name, options)
        end
      end

      def password_field(name, options={})
        labelled_field(name, options) do
          super(name, options)
        end
      end

      def labelled_field(name, options={})
        options[:class] ||= "form-control"

        form_group(class: ("has-error" if object.errors[name].any?)) do
          label(name, options[:label]) + yield + form_errors(name)
        end
      end

      def form_group(options={}, &block)
        @template.content_tag(:div, class: ["form-group", options[:class]].compact, &block)
      end

      def form_errors(name)
        if object.errors[name].any?
          @template.content_tag(:p, class: "help-block") do
            @template.safe_join([
              @template.content_tag(:i, "", class: "fa fa-warning"),
              object.errors[name].first
            ], " ")
          end
        end
      end
    end
  end
end
