require 'spec_helper'

describe Trestle::Navigation::Block do
  describe "#items" do
    it "returns the navigation items defined in the block" do
      block = Trestle::Navigation::Block.new do
        item :basic
        item :with_path, "/123"
        item :with_options, icon: "fa fa-plus"
        item :with_path_and_options, "/path", icon: "fa fa-plus"
      end

      expect(block.items[0]).to eq(Trestle::Navigation::Item.new(:basic))

      expect(block.items[1]).to eq(Trestle::Navigation::Item.new(:with_path, "/123"))

      expect(block.items[2]).to eq(Trestle::Navigation::Item.new(:with_options, nil))
      expect(block.items[2].options).to eq(icon: "fa fa-plus")

      expect(block.items[3]).to eq(Trestle::Navigation::Item.new(:with_path_and_options, "/path"))
      expect(block.items[3].options).to eq(icon: "fa fa-plus")
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

        item :single_line_group, group: :group3
      end

      expect(block.items.map(&:group)).to eq([
        Trestle::Navigation::Group.new(:group1),
        Trestle::Navigation::Group.new(:group2),
        Trestle::Navigation::NullGroup.new,
        Trestle::Navigation::Group.new(:group3)
      ])
    end
  end
end
