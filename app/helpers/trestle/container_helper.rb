module Trestle
  module ContainerHelper
    def container(&block)
      context = Context.new(self)
      content = capture(context, &block)

      tag.div(class: "main-content-container") do
        concat tag.div(content, class: "main-content")
        concat context.sidebar if context.sidebar
      end
    end

    class Context
      def initialize(template)
        @template = template
      end

      def sidebar(options={}, &block)
        if block_given?
          @sidebar = @template.tag.aside(**default_sidebar_options.merge(options), &block)
          nil
        else
          @sidebar
        end
      end

      def default_sidebar_options
        Trestle::Options.new(class: ["main-content-sidebar"])
      end
    end
  end
end
