require 'spec_helper'

describe Trestle::Navigation::Group do
  subject(:group) { Trestle::Navigation::Group.new(:test) }

  it "has a label based on the internationalized name" do
    expect(I18n).to receive(:t).with("admin.navigation.groups.test", default: "Test").and_return("Test")
    expect(group.label).to eq("Test")
  end

  it "has a default priority of 0" do
    expect(group.priority).to eq(0)
  end

  it "sorts by priority" do
    g1 = Trestle::Navigation::Group.new(:test1)
    g2 = Trestle::Navigation::Group.new(:test2, priority: :first)
    g3 = Trestle::Navigation::Group.new(:test3, priority: :last)
    g4 = Trestle::Navigation::Group.new(:test4, priority: 50)

    expect([g1, g2, g3, g4].sort).to eq([g2, g1, g4, g3])
  end

  it "has an id based on the name" do
    expect(group.id).to eq("test")
  end
end

describe Trestle::Navigation::NullGroup do
  it "is not present" do
    expect(subject).to_not be_present
  end

  it "always sorts before regular groups" do
    null = Trestle::Navigation::NullGroup.new
    group = Trestle::Navigation::Group.new(:test, priority: :first)

    expect([group, null].sort).to eq([null, group])
  end

  it "has a nil id" do
    expect(subject.id).to be_nil
  end
end
