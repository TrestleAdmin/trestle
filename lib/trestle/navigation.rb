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
      Hash[stable_sort(items.group_by(&:group)).map { |group, items| [group, stable_sort(items)] }]
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
  end
end
