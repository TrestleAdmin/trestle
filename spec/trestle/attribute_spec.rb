require 'spec_helper'

describe Trestle::Attribute do
  let(:model) { double(primary_key: "id", inheritance_column: "type") }

  subject(:attribute) { Trestle::Attribute.new(:name, :string) }

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
