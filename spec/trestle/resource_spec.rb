require 'spec_helper'

describe Trestle::Resource do
  before(:each) do
    class TestAdmin < Trestle::Resource; end
  end

  after(:each) do
    Object.send(:remove_const, :TestAdmin)
    Object.send(:remove_const, :Test) if defined?(Test)
  end

  subject(:admin) { TestAdmin }

  it "is a subclass of Admin" do
    expect(admin).to be < Trestle::Admin
  end

  it "infers the model from the admin name" do
    class Test; end
    expect(admin.model).to eq(Test)
  end

  it "raises an exception if the inferred model does not exist" do
    expect { admin.model }.to raise_exception(NameError, "Unable to find model Test. Specify a different model using Trestle.resource(:test, model: MyModel)")
  end

  it "allows the model to be specified manually via options" do
    class AlternateModel; end
    admin.options = { model: AlternateModel }
    expect(admin.model).to eq(AlternateModel)
  end

  context "scoped within a module" do
    before(:each) do
      module Scoped
        class Test; end
        class TestAdmin < Trestle::Resource; end
      end
    end

    after(:each) do
      Scoped.send(:remove_const, :TestAdmin)
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

  it "has a default instance block" do
    class Test; end
    expect(Test).to receive(:find).with(123).and_return(1)
    expect(admin.find_instance(id: 123)).to eq(1)
  end

  it "has a default paginate block" do
    collection = double
    expect(collection).to receive(:page).with(5).and_return([1, 2, 3])
    expect(admin.paginate(collection, page: 5)).to eq([1, 2, 3])
  end

  it "has a default (identity) decorator" do
    collection = double
    expect(admin.decorate_collection(collection)).to eq(collection)
  end

  describe "#model_name" do
    before(:each) do
      class Test; end
    end

    context "#model_name on the class returns an ActiveModel::Name" do
      it "returns the humanized model name" do
        model_name = double(human: "ActiveModel Class")

        expect(Test).to receive(:model_name).and_return(model_name)
        expect(admin.model_name).to eq("ActiveModel Class")
      end
    end

    context "#model_name on the class returns a string" do
      it "returns the titleized model name" do
        expect(Test).to receive(:model_name).and_return("TestClass")
        expect(admin.model_name).to eq("Test Class")
      end
    end

    it "can be overridden via the `as` option" do
      admin.options = { as: "Custom Class" }

      expect(Test).to_not receive(:model_name)
      expect(admin.model_name).to eq("Custom Class")
    end
  end

  describe "#apply_sorting" do
    let(:collection) { double }
    let(:sorted_collection) { double }

    context "when given sort params" do
      it "reorders the given collection" do
        expect(collection).to receive(:reorder).with(field: "asc").and_return(sorted_collection)
        expect(admin.apply_sorting(collection, sort: "field", order: "asc")).to eq(sorted_collection)
      end
    end

    context "when given no sort params" do
      it "returns the given collection" do
        expect(admin.apply_sorting(collection, {})).to eq(collection)
      end
    end

    context "when a column sort for the field exists" do
      it "reorders the collection using the column sort" do
        TestAdmin.column_sorts[:field] = ->(collection, order) { collection.order(field: order) }

        expect(collection).to receive(:order).with(field: "desc").and_return(sorted_collection)
        expect(admin.apply_sorting(collection, sort: "field", order: "desc")).to eq(sorted_collection)
      end
    end
  end
end
