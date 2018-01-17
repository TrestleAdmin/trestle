module Trestle
  module PanelHelper
    def panel(options={}, &block)
      html_class = options.fetch(:class) { "panel-default" }

      content_tag(:div, class: ["panel", html_class]) do
        if options[:title]
          concat content_tag(:div, options[:title], class: "panel-heading")
        end

        concat content_tag(:div, class: "panel-body", &block)

        if options[:footer]
          concat content_tag(:div, options[:footer], class: "panel-footer")
        end
      end
    end

    def well(options={}, &block)
      html_class = ["well", options[:class]].compact
      content_tag(:div, options.merge(class: html_class), &block)
    end
  end
end
