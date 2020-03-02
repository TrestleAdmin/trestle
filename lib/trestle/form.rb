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

    def dialog?
      options[:dialog] == true
    end

    def render(template, instance)
      Renderer.new(template).render_form(instance, &block)
    end
  end
end
