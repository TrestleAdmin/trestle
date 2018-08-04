module Trestle
  class Hook
    attr_reader :name, :options, :block

    def initialize(name, options={}, &block)
      @name, @options, @block = name, options, block
    end

    def ==(other)
      other.is_a?(self.class) && name == other.name && options == other.options && block == other.block
    end

    def visible?(context)
      if options[:if]
        context.instance_exec(&options[:if])
      elsif options[:unless]
        !context.instance_exec(&options[:unless])
      else
        true
      end
    end

    def evaluate(context)
      context.instance_exec(&block)
    end
  end
end
