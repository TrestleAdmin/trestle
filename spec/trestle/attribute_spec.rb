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

    subject(:association) { Trestle::Attribute::Association.new(:user_id, association_class) }

    describe "#association_name" do
      it "returns the name without the trailing _id" do
        expect(subject.association_name).to eq("user")
      end
    end
  end
end
