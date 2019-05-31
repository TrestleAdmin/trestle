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

    class Set
      attr_reader :hooks

      def initialize
        @hooks = {}
      end

      def append(name, options={}, &block)
        hooks[name.to_s] ||= []
        hooks[name.to_s] << Hook.new(name.to_s, options, &block)
      end

      def any?(name)
        hooks.key?(name.to_s) && hooks[name.to_s].any?
      end

      def for(name)
        hooks.fetch(name.to_s) { [] }
      end

      def empty?
        hooks.empty?
      end

      def ==(other)
        other.is_a?(self.class) && hooks == other.hooks
      end
    end
  end
end
