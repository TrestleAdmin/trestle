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
      Hash[stable_sort(items.group_by(&:group)).map { |group, items| [group, stable_sort(items)] }]
    end

    def each(&block)
      by_group.each(&block)
    end

    def first
      sorted = by_group.values
      sorted.first.first if sorted.any?
    end

  private
    def stable_sort(items)
      items.sort_by.with_index { |item, i| [item, i] }
    end
  end
end
