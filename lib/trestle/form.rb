module Trestle
  class Form
    extend ActiveSupport::Autoload

    autoload :Automatic
    autoload :Builder
    autoload :Field
    autoload :Fields
    autoload :Renderer

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
