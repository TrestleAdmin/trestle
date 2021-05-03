require 'spec_helper'

describe Trestle::Registry, remove_const: true do
  subject(:registry) { Trestle::Registry.new }

  let(:admin) { double(admin_name: "test") }

  it "is initially empty" do
    expect(registry).to be_empty
    expect(registry.to_a).to eq([])
  end

  describe "#register" do
    it "registers the given admin" do
      registry.register(admin)

      expect(registry).not_to be_empty
      expect(registry.to_a).to eq([admin])
    end
  end

  describe "#each" do
    let(:first_admin) { double(admin_name: "a-test") }
    let(:last_admin) { double(admin_name: "z-test") }

    it "yields each admin alphabetically by admin name" do
      registry.register(admin)
      registry.register(last_admin)
      registry.register(first_admin)

      expect { |b| registry.each(&b) }.to yield_successive_args(first_admin, admin, last_admin)
    end
  end

  describe "#reset!" do
    it "clears out the registry" do
      registry.register(admin)
      registry.reset!

      expect(registry).to be_empty
      expect(registry.to_a).to eq([])
    end
  end

  describe "#lookup" do
    before(:each) do
      registry.register(Trestle.admin(:test))
    end

    context "given an admin class" do
      it "returns the admin class" do
        expect(registry.lookup(TestAdmin)).to eq(TestAdmin)
      end
    end

    context "given a string or symbol" do
      it "returns the admin class corresponding to the given string/symbol" do
        expect(registry.lookup(:test)).to eq(TestAdmin)
        expect(registry.lookup("test")).to eq(TestAdmin)
      end

      it "returns nil if no matching admin is found" do
        expect(registry.lookup(:missing)).to be_nil
      end
    end
  end

  describe "#lookup_model" do
    let(:model) { stub_const("Model", Class.new) }
    let(:subclass) { stub_const("SubClass", model) }

    let(:admin) { Trestle.resource(:test, model: model) }

    before(:each) do
      registry.register(admin)
    end

    it "returns the admin associated with the given model's class" do
      expect(registry.lookup_model(model)).to eq(admin)
    end

    it "tries the given model's ancestors" do
      expect(registry.lookup_model(subclass)).to eq(admin)
    end

    it "returns nil if there is no associated admin" do
      missing = stub_const("Missing", Class.new)
      expect(registry.lookup_model(missing)).to be_nil
    end
  end
end
