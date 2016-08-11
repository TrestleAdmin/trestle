require 'spec_helper'

describe Trestle::Navigation::Block do
  describe "#items" do
    it "returns the navigation items defined in the block" do
      block = Trestle::Navigation::Block.new do
        item :basic
        item :with_path, "/123"
        item :with_options, "/path", icon: "fa fa-plus"
      end

      expect(block.items).to eq([
        Trestle::Navigation::Item.new(:basic),
        Trestle::Navigation::Item.new(:with_path, "/123"),
        Trestle::Navigation::Item.new(:with_options, "/path", icon: "fa fa-plus")
      ])
    end

    it "applies the group to the item" do
      block = Trestle::Navigation::Block.new do
        group :group1 do
          item :in_first_group
        end

        group :group2 do
          item :in_second_group
        end

        item :ungrouped
      end

      expect(block.items.map(&:group)).to eq([
        Trestle::Navigation::Group.new(:group1),
        Trestle::Navigation::Group.new(:group2),
        Trestle::Navigation::NullGroup.new
      ])
    end
  end
end
