require 'spec_helper'

describe Trestle::Attribute do
  describe "#array?" do
    it "returns true when options[:array] is true" do
      attribute = Trestle::Attribute.new(:name, :string, array: true)
      expect(attribute.array?).to be true
    end

    it "returns false when options[:array] is false" do
      attribute = Trestle::Attribute.new(:name, :string)
      expect(attribute.array?).to be false
    end
  end

  describe Trestle::Attribute::Association do
    let(:association_class) { double(name: "User") }

    subject(:association) { Trestle::Attribute::Association.new(:user_id) }

    describe "#association_name" do
      it "returns options[:name]" do
        association = Trestle::Attribute::Association.new(:user_id, name: "custom")
        expect(association.association_name).to eq("custom")
      end

      it "returns the column name without the trailing _id if not explicitly provided" do
        expect(association.association_name).to eq("user")
      end
    end

    describe "#association_class" do
      it "returns options[:class]" do
        klass = double
        association = Trestle::Attribute::Association.new(:user_id, class: klass)
        expect(association.association_class).to eq(klass)
      end

      it "calls options[:class] if it is a block" do
        klass = double
        association = Trestle::Attribute::Association.new(:user_id, class: -> { klass })
        expect(association.association_class).to eq(klass)
      end
    end

    describe "#polymorphic?" do
      it "returns true when options[:polymorphic] is true" do
        association = Trestle::Attribute::Association.new(:user_id, polymorphic: true)
        expect(association.polymorphic?).to be true
      end

      it "returns false when options[:array] is false" do
        expect(association.polymorphic?).to be false
      end
    end
  end
end
