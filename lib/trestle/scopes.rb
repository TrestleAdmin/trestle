module Trestle
  class Scopes
    require_relative "scopes/block"
    require_relative "scopes/scope"

    attr_reader :admin, :blocks

    def initialize(admin)
      @admin = admin
      @blocks = []
    end

    def append(&block)
      @blocks << Block.new(admin, &block)
    end

    def evaluate(context)
      @blocks.map { |block| block.scopes(context) }.flatten.index_by(&:name)
    end
  end
end
