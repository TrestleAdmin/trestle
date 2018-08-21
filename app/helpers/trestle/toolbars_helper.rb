module Trestle
  module ToolbarsHelper
    def toolbar(name, &block)
      toolbar = (toolbars[name.to_s] ||= Toolbar.new)
      toolbar.prepend(&block) if block_given?
      toolbar
    end

    def toolbars
      @_toolbars ||= {}
    end

    def render_toolbar(toolbar, *args)
      result = toolbar.groups(self, *args).map do |items|
        if items.many?
          content_tag(:div, class: "btn-group", role: "group") do
            safe_join(items, "\n")
          end
        else
          items.first
        end
      end

      safe_join(result, "\n")
    end

    def deprecated_toolbar(name)
      if content_for?(:"#{name}_toolbar")
        ActiveSupport::Deprecation.warn("Using content_for(:#{name}_toolbar) is deprecated. Please use toolbar(:#{name}) instead.")
        content_for(:"#{name}_toolbar")
      end
    end
  end
end
