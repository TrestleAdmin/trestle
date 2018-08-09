module Trestle
  class Toolbar
    def initialize
      @blocks = []
    end

    def items(context)
      @blocks.map { |b| context.capture(&b) }
    end

    def append(&block)
      @blocks.push(block)
    end

    def prepend(&block)
      @blocks.unshift(block)
    end
  end
end
