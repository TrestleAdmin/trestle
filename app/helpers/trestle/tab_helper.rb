module Trestle
  module TabHelper
    def tab(name, options={})
      tabs[name] = tab = Tab.new(name, options)

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

    def tabs
      @_trestle_tabs ||= {}
    end

    def sidebar(&block)
      content_for(:sidebar, &block)
    end

    def render_sidebar_as_tab?
      modal_request? && content_for?(:sidebar)
    end
  end
end
