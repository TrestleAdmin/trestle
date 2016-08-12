require 'spec_helper'

describe Trestle::Navigation::Item do
  subject(:item) { Trestle::Navigation::Item.new(:test) }

  it "has a default priority of 0" do
    expect(item.priority).to eq(0)
  end

  it "has a default group of NullGroup" do
    expect(item.group).to eq(Trestle::Navigation::NullGroup.new)
  end

  it "sets the group from options" do
    group = Trestle::Navigation::Group.new(:test)
    item = Trestle::Navigation::Item.new(:test, nil, group: group)

    expect(item.group).to eq(group)
  end

  it "sorts by priority, then name" do
    i1 = Trestle::Navigation::Item.new(:test1)
    i2 = Trestle::Navigation::Item.new(:test2, priority: :first)
    i3 = Trestle::Navigation::Item.new(:test3, priority: 50)
    i4 = Trestle::Navigation::Item.new(:atest4, priority: 50)
    i5 = Trestle::Navigation::Item.new(:test5, priority: :last)

    expect([i5, i1, i2, i3, i4].sort).to eq([i2, i1, i4, i3, i5])
  end

  context "with a badge" do
    it "has a badge" do
      item = Trestle::Navigation::Item.new(:test, nil, badge: { text: "123", class: "label-success" })

      expect(item.badge?).to be true
      expect(item.badge.text).to eq("123")
      expect(item.badge.html_class).to eq("label-success")
    end

    it "has a badge with a default class if full options not provided" do
      item = Trestle::Navigation::Item.new(:test, nil, badge: "123")

      expect(item.badge?).to be true
      expect(item.badge.text).to eq("123")
      expect(item.badge.html_class).to eq("label-primary")
    end
  end
end
