module Trestle
  module TabHelper
    def tabs
      @_trestle_tabs ||= {}
    end

    def tab(name, options={})
      tabs[name] = Tab.new(name, options)

      content_tag(:div, id: "tab-#{name}", class: ["tab-pane", ('active' if name == tabs.keys.first)], role: "tabpanel") do
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
