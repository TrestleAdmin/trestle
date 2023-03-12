require 'spec_helper'

describe Trestle::DebugErrors do
  class MyClass
    extend ActiveModel::Naming

    def initialize
      @attrs = { attribute: "abc", another: 123 }
    end

    def read_attribute_for_validation(attr)
      @attrs[attr]
    end

    def self.human_attribute_name(attr, options = {})
      attr
    end
  end

  let(:instance) { MyClass.new }
  let(:errors) { ActiveModel::Errors.new(instance) }

  subject(:debug_errors) { Trestle::DebugErrors.new(errors) }

  describe "#any?" do
    it "returns false if there are no errors" do
      expect(errors.any?).to be false
    end

    it "returns true if there are errors" do
      errors.add(:attribute, :invalid)
      expect(errors.any?).to be true
    end
  end

  describe "#each" do
    it "iterates over each error yielding the attribute and message" do
      errors.add(:attribute, :invalid)
      errors.add(:attribute, :taken)
      errors.add(:another, :invalid)

      expect { |b| debug_errors.each(&b) }.to yield_successive_args(
        [:attribute, "is invalid"],
        [:attribute, "has already been taken"],
        [:another, "is invalid"]
      )
    end
  end
end
