require 'spec_helper'

describe Trestle::Navigation::Item do
  subject(:item) { Trestle::Navigation::Item.new(:test) }

  it "has a label based on the internationalized name" do
    expect(I18n).to receive(:t).with("admin.menu.item.test", default: "Test").and_return("Test")
    expect(item.label).to eq("Test")
  end

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

  it "has a default icon" do
    expect(item.icon).to eq(Trestle.config.default_navigation_icon)
  end

  it "sets the icon from options" do
    item = Trestle::Navigation::Item.new(:test, nil, icon: "fa fa-user")
    expect(item.icon).to eq("fa fa-user")
  end

  it "sorts by priority" do
    i1 = Trestle::Navigation::Item.new(:test1)
    i2 = Trestle::Navigation::Item.new(:test2, nil, priority: :first)
    i3 = Trestle::Navigation::Item.new(:test3, nil, priority: :last)
    i4 = Trestle::Navigation::Item.new(:test4, nil, priority: 50)

    expect([i1, i2, i3, i4].sort).to eq([i2, i1, i4, i3])
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
