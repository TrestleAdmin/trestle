module Trestle
  class Hook
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
