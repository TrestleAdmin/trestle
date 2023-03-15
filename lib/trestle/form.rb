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
    end

    def modal?
      options[:modal] || options[:dialog] == true
    end

    def dialog?
      ActiveSupport::Deprecation.warn("`Trestle::Form#dialog?` is deprecated. Please use `modal?` instead.")
      options[:dialog] == true
    end

    def render(template, instance)
      Renderer.new(template).render_form(instance, &block)
    end
  end
end
