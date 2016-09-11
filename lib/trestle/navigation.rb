module Trestle
  class Navigation
    extend ActiveSupport::Autoload

    autoload :Block
    autoload :Item
    autoload :Group
    autoload :NullGroup, "trestle/navigation/group"

    def initialize(blocks)
      @blocks = blocks
    end

    def items
      @blocks.map(&:items).flatten
    end

    def by_group
      Hash[items.group_by(&:group).sort_by { |group, items| group }.map { |group, items| [group, items.sort] }]
    end

    def each(&block)
      by_group.each(&block)
    end

    def first
      by_group.values.first.first
    end
  end
end
