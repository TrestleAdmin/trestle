module Trestle
  module ToolbarsHelper
    def toolbar(name, &block)
      toolbar = (toolbars[name.to_s] ||= Toolbar.new)
      toolbar.append(&block) if block_given?
      toolbar
    end

    def toolbars
      @_toolbars ||= {}
    end

    def deprecated_toolbar(name)
      if content_for?(:"#{name}_toolbar")
        ActiveSupport::Deprecation.warn("Using content_for(:#{name}_toolbar) is deprecated. Please use toolbar(:#{name}) instead.")
        content_for(:"#{name}_toolbar")
      end
    end
  end
end
