module Trestle
  class Navigation
    extend ActiveSupport::Autoload

    autoload :Block
    autoload :Item
    autoload :Group
    autoload :NullGroup, "trestle/navigation/group"

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

    def visible(context)
      self.class.new(items.select { |item| item.visible?(context) })
    end

    def self.build(blocks)
      new(blocks.map(&:items).flatten)
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
