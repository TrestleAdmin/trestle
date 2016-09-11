module Trestle
  class Form
    extend ActiveSupport::Autoload

    autoload :Builder
    autoload :Renderer

    attr_reader :block

    def initialize(&block)
      @block = block
    end

    def render(template, instance)
      Renderer.new(template).render(instance, &block)
    end
  end
end
