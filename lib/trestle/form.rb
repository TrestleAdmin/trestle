module Trestle
  class Form
    require_relative "form/automatic"
    require_relative "form/builder"
    require_relative "form/field"
    require_relative "form/fields"
    require_relative "form/renderer"

    attr_reader :options, :block

    def initialize(options={}, &block)
      @options, @block = options, block

      if @options[:modal] == true
        @options[:modal] = {}
      end

      if options[:dialog]
        Trestle.deprecator.warn("`form dialog: true` is deprecated. Please use `form modal: true` instead.")
        @options.delete(:dialog)
        @options[:modal] = {}
      end
    end

    def modal?
      options[:modal]
    end

    def dialog?
      Trestle.deprecator.warn("`Trestle::Form#dialog?` is deprecated. Please use `modal?` instead.")
      options[:modal]
    end

    def render(template, instance)
      Renderer.new(template).render_form(instance, &block)
    end
  end
end
