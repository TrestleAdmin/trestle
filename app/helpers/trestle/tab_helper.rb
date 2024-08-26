module Trestle
  module TabHelper
    # Creates a tab pane using content via the given block, :partial option or partial
    # template automatically inferred from the tab name.
    #
    # It also appends a Trestle::Tab object to the list of declared tabs that is
    # accessible via the #tabs helper (e.g. for rendering the tab links).
    #
    # name    - (Symbol) Internal name for the tab
    # options - Hash of options (default: {}):
    #           :label - Optional tab label. If not provided, will be inferred by the
    #                    admin-translated tab name (`admin.tabs.{name}` i18n scope)
    #           :badge - Optional badge to show next to the tab label (e.g. a counter)
    #           :partial - Optional partial template name to use when a block is not provided
    #
    # Examples
    #
    #   <%= tab :details %>
    #   => Automatically renders the 'details' partial (e.g. "_details.html.erb") as the tab content
    #
    #   <%= tab :metadata, partial: "meta" %>
    #   => Renders the 'meta' partial (e.g. "_meta.html.erb") as the tab content
    #
    #   <%= tab :comments do %> ...
    #   => Renders the given block as the tab content
    #
    # Returns a HTML-safe String.
    def tab(name, **options)
      tabs[name] = tab = Tab.new(name, **options)

      tag.div(id: tab.id(("modal" if modal_request?)), class: ["tab-pane", ('active' if name == tabs.keys.first)], role: "tabpanel") do
        if block_given?
          yield
        elsif options[:partial]
          render partial: options[:partial]
        else
          render partial: name.to_s
        end
      end
    end

    # Returns a hash (name => Trestle::Tab) of the currently declared tabs.
    def tabs
      @_trestle_tabs ||= {}
    end

    # Captures the given block (using `content_for`) as the sidebar content.
    def sidebar(&block)
      content_for(:sidebar, &block)
    end

    def render_sidebar_as_tab?
      modal_request? && content_for?(:sidebar)
    end
  end
end
