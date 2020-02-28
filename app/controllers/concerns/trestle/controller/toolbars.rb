module Trestle
  module Controller
    module Toolbars
      extend ActiveSupport::Concern

      included do
        helper_method :toolbars
        helper_method :toolbar
      end

    protected
      def toolbars
        @_toolbars ||= {}
      end

      def toolbar(name, options={}, &block)
        builder = options[:builder] || default_toolbar_builder

        toolbar = (toolbars[name.to_s] ||= Toolbar.new(builder))
        toolbar.clear! if options[:clear]
        toolbar.prepend(&block) if block_given?
        toolbar
      end

      def default_toolbar_builder
        Toolbar::Builder
      end
    end
  end
end
