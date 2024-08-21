module Trestle
  module TabHelper
    def tabs
      @_trestle_tabs ||= {}
    end

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
  end
end
