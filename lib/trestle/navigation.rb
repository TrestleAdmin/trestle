module Trestle
  class Navigation
    require_relative "navigation/block"
    require_relative "navigation/item"
    require_relative "navigation/group"

    attr_reader :items

    def initialize(items)
      @items = items
    end

    def by_group
      sorted_groups = stable_sort(items.group_by { |item| groups[item.group.id] })
      sorted_items = sorted_groups.map { |group, items| [group, stable_sort(items)] }

      Hash[sorted_items]
    end

    def each(&block)
      by_group.each(&block)
    end

    def first
      sorted = by_group.values
      sorted.first.first if sorted.any?
    end

    def self.build(blocks, context)
      new(blocks.map { |block|
        block.items(context)
      }.flatten.select { |item|
        item.visible?(context)
      })
    end

  private
    def stable_sort(items)
      items.sort_by.with_index { |item, i| [item, i] }
    end

    def groups
      @groups ||= items.inject({}) { |groups, item|
        group = groups[item.group.id]

        groups[item.group.id] = group ? group.merge(item.group) : item.group
        groups
      }
    end
  end
end
