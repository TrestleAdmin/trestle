require 'spec_helper'

describe Trestle::Navigation::Group do
  it "has a default priority of 0" do
    group = Trestle::Navigation::Group.new(:test)
    expect(group.priority).to eq(0)
  end

  it "sorts by priority, then name" do
    g1 = Trestle::Navigation::Group.new(:test1)
    g2 = Trestle::Navigation::Group.new(:test2, priority: :first)
    g3 = Trestle::Navigation::Group.new(:test3, priority: 50)
    g4 = Trestle::Navigation::Group.new(:atest4, priority: 50)
    g5 = Trestle::Navigation::Group.new(:test5, priority: :last)

    expect([g5, g1, g2, g3, g4].sort).to eq([g2, g1, g4, g3, g5])
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
end
