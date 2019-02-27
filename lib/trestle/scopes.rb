module Trestle
  class Scopes
    extend ActiveSupport::Autoload

    autoload :Block
    autoload :Scope

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
