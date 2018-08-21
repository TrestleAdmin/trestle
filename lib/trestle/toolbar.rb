module Trestle
  class Toolbar
    extend ActiveSupport::Autoload

    autoload :Builder
    autoload :Context

    def initialize(builder=Builder)
      @builder = builder
      @blocks = []
    end

    def groups(template, *args)
      Enumerator.new do |y|
        @blocks.each do |block|
          builder = @builder.new(template, *args)
          block.evaluate(builder, template, y, *args)
        end
      end
    end

    def append(&block)
      @blocks.push(Block.new(&block))
    end

    def prepend(&block)
      @blocks.unshift(Block.new(&block))
    end

    # Wraps a toolbar block to provide evaluation within the context of a template and enumerator
    class Block
      def initialize(&block)
        @block = block
      end

      def evaluate(builder, template, enumerator, *args)
        context = Context.new(builder, enumerator, *args)
        result = template.capture { template.instance_exec(context, *args, &@block) }
        enumerator << [result] if result.present?
      end
    end
  end
end
