require 'spec_helper'

describe Trestle::Resource, remove_const: true do
  before(:each) do
    class Test; end
  end

  subject!(:admin) { Trestle.resource(:tests) }

  before(:each) do
    Rails.application.reload_routes!
  end

  it "is a subclass of Resource and Admin" do
    expect(admin).to be < Trestle::Resource
    expect(admin).to be < Trestle::Admin
  end

  it "infers the model from the admin name" do
    expect(admin.model).to eq(Test)
  end

  it "raises an exception if the inferred model does not exist" do
    Object.send(:remove_const, :Test)
    expect { admin.model }.to raise_exception(NameError, "Unable to find model Test. Specify a different model using Trestle.resource(:tests, model: MyModel)")
  end

  it "allows the model to be specified manually via options" do
    class AlternateModel; end
    admin.options = { model: AlternateModel }
    expect(admin.model).to eq(AlternateModel)
  end

  it "has a model name" do
    expect(admin.model_name).to eq(Trestle::ModelName.new(Test))
  end

  it "has a breadcrumb trail" do
    expect(I18n).to receive(:t).with("admin.breadcrumbs.home", default: "Home").and_return("Home")
    expect(I18n).to receive(:t).with("admin.breadcrumbs.tests", default: "Tests").and_return("Tests")

    trail = Trestle::Breadcrumb::Trail.new([
      Trestle::Breadcrumb.new("Home", "/admin"),
      Trestle::Breadcrumb.new("Tests", "/admin/tests")
    ])

    expect(admin.breadcrumbs).to eq(trail)
  end

  it "has a default collection block" do
    expect(Test).to receive(:all).and_return([1, 2, 3])
    expect(admin.collection).to eq([1, 2, 3])
  end

  it "has a default instance block" do
    expect(Test).to receive(:find).with(123).and_return(1)
    expect(admin.find_instance(id: 123)).to eq(1)
  end

  it "has a default paginate block" do
    collection = double
    expect(collection).to receive(:page).with(5).and_return(collection)
    expect(collection).to receive(:per).with(nil).and_return([1, 2, 3])
    expect(admin.paginate(collection, page: 5)).to eq([1, 2, 3])
  end

  it "has a default (identity) decorator" do
    collection = double
    expect(admin.decorate_collection(collection)).to eq(collection)
  end

  describe "#instance_path" do
    let(:instance) { double(id: "123") }

    it "returns the path for the given instance" do
      Rails.application.reload_routes!

      expect(admin.instance_path(instance)).to eq("/admin/tests/123")
      expect(admin.instance_path(instance, action: :edit)).to eq("/admin/tests/123/edit")
      expect(admin.instance_path(instance, action: :edit, foo: :bar)).to eq("/admin/tests/123/edit?foo=bar")
    end
  end

  describe "#translate" do
    it "translates the given key using sensible defaults, passing in the model name" do
      expect(I18n).to receive(:t).with(:"admin.tests.titles.index", {
        default: [:"admin.titles.index", "Index"],
        model_name: "Test",
        lowercase_model_name: "test",
        pluralized_model_name: "Tests"
      }).and_return("Tests Index")

      expect(admin.translate("titles.index", default: "Index")).to eq("Tests Index")
    end
  end

  describe "#prepare_collection" do
    let(:collection) { [3, 1, 2] }

    before(:each) do
      allow(admin).to receive(:initialize_collection).and_return(collection)
    end

    describe "sorting" do
      let(:sorted_collection) { [1, 2, 3] }

      context "when given sort params" do
        it "reorders the given collection" do
          expect(collection).to receive(:reorder).with(field: :asc).and_return(sorted_collection)
          expect(admin.prepare_collection(sort: "field", order: "asc")).to eq(sorted_collection)
        end
      end

      context "when given no sort params" do
        it "returns the given collection" do
          expect(admin.prepare_collection({})).to eq(collection)
        end
      end

      context "when a column sort for the field exists" do
        it "reorders the collection using the column sort" do
          TestsAdmin.column_sorts[:field] = ->(collection, order) { collection.order(field: order) }

          expect(collection).to receive(:order).with(field: :desc).and_return(sorted_collection)
          expect(admin.prepare_collection(sort: "field", order: "desc")).to eq(sorted_collection)
        end
      end
    end
  end

  context "scoped within a module" do
    subject!(:admin) do
      module Scoped
        class Test; end
      end

      Trestle.resource(:tests, scope: Scoped)
    end

    it "infers the model from the module and admin name" do
      expect(admin.model).to eq(Scoped::Test)
    end
  end

  context "a singular resource" do
    subject!(:admin) do
      Trestle.resource(:singular, singular: true) do
        instance {}
      end
    end

    it "is singular" do
      expect(admin).to be_singular
    end

    it "returns the show action path as the default path" do
      expect(admin.path).to eq("/admin/singular")
    end

    context "without an instance block" do
      subject!(:admin) { nil }

      it "raises a NotImplementedError exception" do
        expect {
          Trestle.resource(:singular, singular: true)
        }.to raise_error(NotImplementedError, "Singular resources must define an instance block.")
      end
    end
  end
end
