module Trestle
  class Scopes
    class Definition
      attr_reader :blocks, :options

      def initialize
        @blocks = []
        @options = {}
      end

      def append(options={}, &block)
        @blocks << Block.new(options, &block)
      end

      def apply_options!(options)
        @options.merge!(options)
      end

      # Evaluates each of the scope blocks within the given admin context
      # and returns a hash of Scope objects keyed by the scope name.
      def evaluate(context)
        @blocks.map { |block| block.scopes(context) }.flatten.index_by(&:name)
      end
    end
  end
end
