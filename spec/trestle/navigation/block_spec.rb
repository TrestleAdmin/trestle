require 'spec_helper'

describe Trestle::Navigation::Block do
  let(:context) { double }

  describe "#items" do
    it "returns the navigation items defined in the block" do
      block = Trestle::Navigation::Block.new do
        item :basic
        item :with_path, "/123"
        item :with_options, icon: "fa fa-plus"
        item :with_path_and_options, "/path", icon: "fa fa-plus"
      end

      items = block.items(context)

      expect(items[0]).to eq(Trestle::Navigation::Item.new(:basic))

      expect(items[1]).to eq(Trestle::Navigation::Item.new(:with_path, "/123"))

      expect(items[2]).to eq(Trestle::Navigation::Item.new(:with_options, nil))
      expect(items[2].options).to eq(icon: "fa fa-plus")

      expect(items[3]).to eq(Trestle::Navigation::Item.new(:with_path_and_options, "/path"))
      expect(items[3].options).to eq(icon: "fa fa-plus")
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

      expect(block.items(context).map(&:group)).to eq([
        Trestle::Navigation::Group.new(:group1),
        Trestle::Navigation::Group.new(:group2),
        Trestle::Navigation::NullGroup.new,
        Trestle::Navigation::Group.new(:group3)
      ])
    end

    it "delegates missing methods to the given context" do
      expect(context).to receive(:context_method)

      block = Trestle::Navigation::Block.new do
        context_method
      end

      block.items(context)
    end
  end

  context "bound to an admin" do
    let(:admin) { double(path: "/123") }

    it "uses the admin path as the default item path" do
      block = Trestle::Navigation::Block.new(admin) do
        item :default_path
        item :custom_path, "/custom"
      end

      items = block.items(context)

      expect(items[0].path).to eq("/123")
      expect(items[1].path).to eq("/custom")
    end

    it "yields the admin to the block" do
      expect { |b| Trestle::Navigation::Block.new(admin, &b).items(context) }.to yield_with_args(admin)
    end

    it "applies the admin to the items" do
      block = Trestle::Navigation::Block.new(admin) do
        item :item
      end

      items = block.items(context)

      expect(items[0].admin).to eq(admin)
    end
  end
end
