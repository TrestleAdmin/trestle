require 'spec_helper'

describe Trestle::Navigation::Item do
  subject(:item) { Trestle::Navigation::Item.new(:test) }

  it "has a default priority of 0" do
    expect(item.priority).to eq(0)
  end

  it "has group NullGroup if no group set" do
    expect(item.group).to eq(Trestle::Navigation::NullGroup.new)
  end

  it "sets the group from options if provided" do
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
end
