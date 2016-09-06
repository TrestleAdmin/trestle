require 'spec_helper'

describe Trestle::Resource do
  before(:each) do
    Object.send(:remove_const, :TestAdmin) if defined?(TestAdmin)
    class TestAdmin < Trestle::Resource; end
  end

  subject(:admin) { TestAdmin }

  it "is a subclass of Admin" do
    expect(admin).to be < Trestle::Admin
  end

  it "infers the model from the admin name" do
    class Test; end
    expect(admin.model).to eq(Test)
  end

  it "allows the model to be specified manually via options" do
    class AlternateModel; end
    admin.options = { model: AlternateModel }
    expect(admin.model).to eq(AlternateModel)
  end

  context "scoped within a module" do
    before(:each) do
      Scoped.send(:remove_const, :TestAdmin) if defined?(Scoped::TestAdmin)

      module Scoped
        class Test; end
        class TestAdmin < Trestle::Resource; end
      end
    end

    subject(:admin) { Scoped::TestAdmin }

    it "infers the model from the module and admin name" do
      expect(admin.model).to eq(Scoped::Test)
    end
  end

  it "has a default collection block" do
    class Test; end
    expect(Test).to receive(:all).and_return([1, 2, 3])
    expect(admin.collection).to eq([1, 2, 3])
  end

  it "has a default paginate block" do
    collection = double
    expect(collection).to receive(:page).with(5).and_return([1, 2, 3])
    expect(admin.paginate(collection, page: 5)).to eq([1, 2, 3])
  end

  it "has a default (identity) decorator" do
    collection = double
    expect(admin.decorate(collection)).to eq(collection)
  end

  describe "#model_name" do
    it "returns the model name" do
      class Test; end

      expect(Test).to receive(:model_name).and_return("Test Class")
      expect(admin.model_name).to eq("Test Class")
    end

    it "can be overridden via the `as` option" do
      admin.options = { as: "Custom Class" }

      expect(Test).to_not receive(:model_name)
      expect(admin.model_name).to eq("Custom Class")
    end
  end
end
