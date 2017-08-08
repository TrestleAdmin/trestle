module Trestle
  module ContainerHelper
    def container(&block)
      context = Context.new(self)
      content = capture(context, &block)

      content_tag(:div, class: "main-content-container") do
        concat content_tag(:div, content, class: "main-content")
        concat content_tag(:aside, context.sidebar, class: "main-content-sidebar") unless context.sidebar.blank?
      end
    end

    class Context
      def initialize(template)
        @template = template
      end

      def sidebar(&block)
        @sidebar = @template.capture(&block) if block_given?
        @sidebar
      end
    end
  end
end
