module Trestle
  module ContainerHelper
    # Renders a content container with an optional sidebar, which can
    # be useful when creating an admin or dashboard with a custom view.
    #
    # This helper accepts a block (within which the main content is provided),
    # which yields a `Context` capture object. The Context object has one important
    # method -- `sidebar(**attributes, &block)` which captures the sidebar content
    # to be rendered after the main content.
    #
    # attributes - Additional HTML attributes to add to the <div> tag
    #
    # Examples
    #
    #   <%= container do |c| %>
    #     This content will be wrapped in a .main-content-container > .main-content div.
    #   <% end %>
    #
    #   <%= container do |c| %>
    #     <% c.sidebar class: "order-first" %>
    #       Sidebar content...
    #     <% end %>
    #     Main content...
    #   <% end %>
    #
    # Returns a HTML-safe String.
    def container(**attributes, &block)
      context = Context.new(self)
      content = capture(context, &block) if block_given?

      tag.div(**attributes.merge(class: ["main-content-container", attributes[:class]])) do
        concat tag.div(content, class: "main-content")
        concat context.sidebar if context.sidebar
      end
    end

    class Context
      def initialize(template)
        @template = template
      end

      # Captures or renders the sidebar for a container block.
      #
      # When passed a block, the block content is captured as the sidebar content, and nil is returned.
      # When no block is provided, the sidebar tag is returned (if defined).
      #
      # attributes - Additional HTML attributes to add to the <div> tag
      def sidebar(**attributes, &block)
        if block_given?
          @sidebar = @template.tag.aside(**default_sidebar_options.merge(attributes), &block)
          nil
        else
          @sidebar
        end
      end

    protected
      def default_sidebar_options
        Trestle::Options.new(class: ["main-content-sidebar"])
      end
    end
  end
end
