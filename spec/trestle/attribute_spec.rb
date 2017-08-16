require 'spec_helper'

describe Trestle::Attribute do
  let(:model) { double(primary_key: "id", inheritance_column: "type") }
  let(:admin) { double(model: model) }

  subject(:attribute) { Trestle::Attribute.new(admin, :name, :string) }

  describe "#association?" do
    it "returns false" do
      expect(subject.association?).to be false
    end
  end

  describe "#boolean?" do
    it "returns true if the attribute has type boolean" do
      expect(Trestle::Attribute.new(admin, :published, :boolean)).to be_boolean
    end
  end

  describe "#text?" do
    it "returns true if the attribute has type text" do
      expect(Trestle::Attribute.new(admin, :body, :text)).to be_text
    end
  end

  describe "#datetime?" do
    it "returns true if the attribute has type date" do
      expect(Trestle::Attribute.new(admin, :timestamp, :date)).to be_datetime
    end

    it "returns true if the attribute has type time" do
      expect(Trestle::Attribute.new(admin, :timestamp, :time)).to be_datetime
    end

    it "returns true if the attribute has type datetime" do
      expect(Trestle::Attribute.new(admin, :timestamp, :datetime)).to be_datetime
    end
  end

  describe Trestle::Attribute::Association do
    let(:association_class) { double(name: "User") }

    subject(:association) { Trestle::Attribute::Association.new(admin, :user_id, association_class) }

    describe "#association?" do
      it "returns true" do
        expect(subject.association?).to be true
      end
    end

    describe "#association_name" do
      it "returns the name without the trailing _id" do
        expect(subject.association_name).to eq("user")
      end
    end

    describe "#association_admin" do
      it "looks up the admin based on the class name" do
        expect(Trestle.admins).to receive(:[]).with("users")
        subject.association_admin
      end
    end
  end
end
