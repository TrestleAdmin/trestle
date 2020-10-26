module Trestle
  class Scopes
    require_relative "scopes/block"
    require_relative "scopes/scope"

    attr_reader :blocks

    def initialize
      @blocks = []
    end

    def append(&block)
      @blocks << Block.new(&block)
    end

    # Evaluates each of the scope blocks within the given admin context
    # and returns a hash of Scope objects keyed by the scope name.
    def evaluate(context)
      @blocks.map { |block| block.scopes(context) }.flatten.index_by(&:name)
    end
  end
end
