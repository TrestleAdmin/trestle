require 'spec_helper'

describe Trestle::Resource::Builder, remove_const: true do
  before(:each) do
    stub_const("Trestle::ApplicationController", Class.new(ActionController::Base))
  end

  it "creates a top-level Resource subclass" do
    Trestle::Resource::Builder.create(:tests)
    expect(::TestsAdmin).to be < Trestle::Resource
  end

  it "creates an AdminController class" do
    Trestle::Resource::Builder.create(:tests)
    expect(::TestsAdmin::AdminController).to be < Trestle::ResourceController
    expect(::TestsAdmin::AdminController.admin).to eq(::TestsAdmin)
  end

  it "autoloads the controller correctly" do
    Trestle.send(:remove_const, :AdminController)
    Trestle.send(:remove_const, :ResourceController)

    ActiveSupport::Dependencies.clear
    ActiveSupport::Dependencies.mechanism = :load

    # Force autoloading of Admin::Controller before Resource::Controller
    Trestle::AdminController

    expect(Trestle::ResourceController).not_to be(Trestle::AdminController)

    ActiveSupport::Dependencies.mechanism = :require
  end unless (Rails.application.config.eager_load || Rails.configuration.try(:autoloader) == :zeitwerk)

  describe "#table" do
    it "builds an index table with the admin and sortable options set" do
      Trestle::Resource::Builder.create(:tests) do
        table custom: "option" do
          column :test
        end
      end

      expect(::TestsAdmin.tables[:index]).to be_a(Trestle::Table)
      expect(::TestsAdmin.tables[:index].options).to eq(custom: "option", sortable: true, admin: ::TestsAdmin)
      expect(::TestsAdmin.tables[:index].columns[0].field).to eq(:test)
    end

    it "builds a named table with the admin option set" do
      Trestle::Resource::Builder.create(:tests) do
        table :named, custom: "option" do
          column :test
        end
      end

      expect(::TestsAdmin.tables[:named]).to be_a(Trestle::Table)
      expect(::TestsAdmin.tables[:named].options).to eq(custom: "option", admin: ::TestsAdmin)
      expect(::TestsAdmin.tables[:named].columns[0].field).to eq(:test)
    end
  end

  describe "#adapter" do
    it "returns the admin's adapter class" do
      adapter = nil

      Trestle::Resource::Builder.create(:tests) do
        adapter = self.adapter
      end

      expect(adapter).to eq(::TestsAdmin.adapter_class)
    end

    it "evaluates the given block in the context of the adapter class" do
      Trestle::Resource::Builder.create(:tests) do
        adapter do
          def custom_method
            "Custom"
          end
        end
      end

      expect(::TestsAdmin.adapter.custom_method).to eq("Custom")
    end
  end

  describe "#adapter=" do
    it "sets the admin's adapter to (a subclass of) the given class" do
      CustomAdapter = Class.new

      Trestle::Resource::Builder.create(:tests) do
        self.adapter = CustomAdapter
      end

      expect(::TestsAdmin.adapter_class).to be < CustomAdapter
    end
  end

  describe "#remove_action" do
    it "removes the given action(s) from the resource" do
      Trestle::Resource::Builder.create(:tests) do
        remove_action :edit, :update
      end

      expect(::TestsAdmin.actions).to eq([:index, :show, :new, :create, :destroy])
      expect(::TestsAdmin::AdminController).not_to respond_to(:edit)
      expect(::TestsAdmin::AdminController).not_to respond_to(:update)
    end
  end

  describe "#collection" do
    it "sets an explicit collection block" do
      Trestle::Resource::Builder.create(:tests) do
        collection do
          [1, 2, 3]
        end
      end

      expect(::TestsAdmin.collection).to eq([1, 2, 3])
    end
  end

  describe "#find_instance" do
    it "sets an explicit instance block" do
      Trestle::Resource::Builder.create(:test) do
        find_instance do |params|
          params[:id]
        end
      end

      expect(::TestAdmin.find_instance(id: 123)).to eq(123)
    end

    it "is aliased as #instance" do
      Trestle::Resource::Builder.create(:tests) do
        instance do |params|
          params[:id]
        end
      end

      expect(::TestsAdmin.find_instance(id: 123)).to eq(123)
    end
  end

  describe "#build_instance" do
    it "sets an explicit build_instance block" do
      Trestle::Resource::Builder.create(:tests) do
        build_instance do |params|
          params
        end
      end

      expect(::TestsAdmin.build_instance({ name: "Test" })).to eq({ name: "Test" })
    end
  end

  describe "#update_instance" do
    it "sets an explicit update_instance block" do
      Trestle::Resource::Builder.create(:tests) do
        update_instance do |instance, params|
          instance.update_attributes(params)
        end
      end

      instance = double
      expect(instance).to receive(:update_attributes).with(name: "Test")
      expect(::TestsAdmin.update_instance(instance, name: "Test"))
    end
  end

  describe "#save_instance" do
    it "sets an explicit save_instance block" do
      repository = double

      Trestle::Resource::Builder.create(:tests) do
        save_instance do |instance, params|
          repository.save(instance, params)
        end
      end

      instance = double
      expect(repository).to receive(:save).with(instance, context: :admin)
      expect(::TestsAdmin.save_instance(instance, context: :admin))
    end
  end

  describe "#delete_instance" do
    it "sets an explicit delete_instance block" do
      repository = double
      instance = double

      Trestle::Resource::Builder.create(:tests) do
        delete_instance do |instance, params|
          repository.delete(instance, params)
        end
      end

      expect(repository).to receive(:delete).with(instance, name: "Test")
      expect(::TestsAdmin.delete_instance(instance, name: "Test"))
    end
  end

  describe "#params" do
    it "sets an explicit permitted_params block" do
      Trestle::Resource::Builder.create(:tests) do
        params do |params|
          params.require(:test).permit(:name)
        end
      end

      params = ActionController::Parameters.new({ test: { name: "Test", ignored: 123 }})
      expect(::TestsAdmin.permitted_params(params)).to eq(ActionController::Parameters.new(name: "Test").permit!)
    end
  end

  describe "#merge_scopes" do
    it "sets an explicit merge_scopes block" do
      Trestle::Resource::Builder.create(:tests) do
        merge_scopes do |scope, other|
          scope.combine(other)
        end
      end

      collection = double
      other = double

      expect(collection).to receive(:combine).with(other).and_return([1, 2, 3])
      expect(::TestsAdmin.merge_scopes(collection, other)).to eq([1, 2, 3])
    end
  end

  describe "#sort" do
    it "sets an explicit sort block" do
      Trestle::Resource::Builder.create(:tests) do
        sort do |collection, field, order|
          collection.order(field => order)
        end
      end

      collection = double
      expect(collection).to receive(:order).with(name: :asc).and_return([1, 2, 3])
      expect(::TestsAdmin.sort(collection, :name, :asc)).to eq([1, 2, 3])
    end
  end

  describe "#sort_column" do
    it "sets a column sort block" do
      Trestle::Resource::Builder.create(:tests) do
        sort_column(:field) do |collection, order|
          collection.order(:field => order)
        end
      end

      admin = ::TestsAdmin.new
      collection = double

      allow(admin).to receive(:collection).and_return(collection)
      expect(collection).to receive(:order).with(field: :asc).and_return([1, 2, 3])
      expect(admin.prepare_collection(sort: "field", order: "asc")).to eq([1, 2, 3])
    end
  end

  describe "#paginate" do
    it "sets an explicit paginate block" do
      Trestle::Resource::Builder.create(:tests) do
        paginate do |collection, params|
          collection.paginate(page: params[:page])
        end
      end

      collection = double
      expect(collection).to receive(:paginate).with(page: 5).and_return([1, 2, 3])
      expect(::TestsAdmin.paginate(collection, page: 5)).to eq([1, 2, 3])
    end

    it "sets pagination options" do
      Trestle::Resource::Builder.create(:tests) do
        paginate per: 50
      end

      expect(::TestsAdmin.pagination_options).to eq({ per: 50 })

      collection = double
      expect(collection).to receive_message_chain(:page, :per) { [1, 2, 3] }
      expect(::TestsAdmin.paginate(collection, page: 5)).to eq([1, 2, 3])
    end
  end

  describe "#count" do
    it "sets an explicit count block" do
      Trestle::Resource::Builder.create(:tests) do
        count do |collection|
          collection.total_count
        end
      end

      collection = double(total_count: 123)
      expect(::TestsAdmin.count(collection)).to eq(123)
    end
  end

  describe "#decorate_collection" do
    it "sets an explicit count block" do
      Trestle::Resource::Builder.create(:tests) do
        decorate_collection do |collection|
          collection.decorate
        end
      end

      collection = double
      expect(collection).to receive(:decorate).and_return(collection)
      expect(::TestsAdmin.decorate_collection(collection)).to eq(collection)
    end
  end

  describe "#decorator" do
    it "sets a decorator class" do
      class TestDecorator; end

      Trestle::Resource::Builder.create(:tests) do
        decorator TestDecorator
      end

      collection = double
      expect(TestDecorator).to receive(:decorate_collection).with(collection).and_return([1, 2, 3])
      expect(::TestsAdmin.decorate_collection(collection)).to eq([1, 2, 3])
    end
  end

  describe "#scope" do
    it "defines a scope on the admin" do
      b = Proc.new {}

      Trestle::Resource::Builder.create(:tests) do
        scope :my_scope, label: "Custom Label", &b
      end

      admin = ::TestsAdmin.new

      expect(admin.scopes.to_a.length).to eq(1)

      scope = admin.scopes.first

      expect(scope.name).to eq(:my_scope)
      expect(scope.options).to eq(label: "Custom Label")
      expect(scope.block).to eq(b)
    end

    context "with a proc as the second parameter" do
      it "uses the proc as the block" do
        b = Proc.new {}

        Trestle::Resource::Builder.create(:tests) do
          scope :my_scope, b, label: "Custom Label"
        end

        admin = ::TestsAdmin.new

        expect(admin.scopes.to_a.length).to eq(1)

        scope = admin.scopes.first

        expect(scope.name).to eq(:my_scope)
        expect(scope.options).to eq(label: "Custom Label")
        expect(scope.block).to eq(b)
      end
    end
  end

  describe "#scopes" do
    it "adds a scopes block" do
      b = Proc.new {}

      Trestle::Resource::Builder.create(:tests) do
        scopes do
          scope :my_scope, label: "Custom Label", &b
        end
      end

      admin = ::TestsAdmin.new

      expect(admin.scopes.to_a.length).to eq(1)

      scope = admin.scopes.first

      expect(scope.name).to eq(:my_scope)
      expect(scope.options).to eq(label: "Custom Label")
      expect(scope.block).to eq(b)
    end

    it "sets the scope definition options" do
      Trestle::Resource::Builder.create(:tests) do
        scopes group: true, class: "tags"
      end

      admin = ::TestsAdmin.new

      expect(admin.scopes.options).to eq(group: true, class: "tags")
    end
  end

  describe "#return_to" do
    context "given options[:on]" do
      it "sets a return location block for the given action" do
        b = Proc.new {}

        Trestle::Resource::Builder.create(:tests) do
          return_to on: :create, &b
        end

        expect(::TestsAdmin.return_locations[:create]).to eq(b)
      end
    end

    context "without options[:on]" do
      it "sets the return location block for all actions" do
        b = Proc.new {}

        Trestle::Resource::Builder.create(:tests) do
          return_to &b
        end

        expect(::TestsAdmin.return_locations[:create]).to eq(b)
        expect(::TestsAdmin.return_locations[:update]).to eq(b)
        expect(::TestsAdmin.return_locations[:destroy]).to eq(b)
      end
    end
  end
end
