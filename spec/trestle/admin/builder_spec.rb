require 'spec_helper'

describe Trestle::Admin::Builder, remove_const: true do
  before(:each) do
    stub_const("Trestle::ApplicationController", Class.new(ActionController::Base))
  end

  it "creates a top-level Admin subclass" do
    Trestle::Admin::Builder.create(:test)
    expect(::TestAdmin).to be < Trestle::Admin
  end

  context "with a module scope" do
    before(:each) do
      module Scoped; end
    end

    it "creates the Admin subclass within the module scope" do
      Trestle::Admin::Builder.create(:test, scope: Scoped)
      expect(::Scoped::TestAdmin).to be < Trestle::Admin
    end
  end

  it "creates an AdminController class" do
    Trestle::Admin::Builder.create(:test)
    expect(::TestAdmin::AdminController).to be < Trestle::AdminController
    expect(::TestAdmin::AdminController.admin).to eq(::TestAdmin)
  end

  it "transfer the options on the Admin class" do
    options = { custom: "option" }
    Trestle::Admin::Builder.create(:test, options)
    expect(TestAdmin.options).to eq(options)
  end

  describe "#menu" do
    let(:context) { double }

    it "sets the admin's menu to a bound navigation block" do
      Trestle::Admin::Builder.create(:test) do
        menu do
        end
      end

      expect(::TestAdmin.menu).to be_a(Trestle::Navigation::Block)
      expect(::TestAdmin.menu.admin).to eq(::TestAdmin)
    end

    it "uses a single-line menu definition if no block provided" do
      Trestle::Admin::Builder.create(:test) do
        menu :test, "/path"
      end

      expect(::TestAdmin.menu.items(context)).to eq([Trestle::Navigation::Item.new(:test, "/path")])
    end
  end

  describe "#admin" do
    it "evaluates the block in the context of the admin" do
      Trestle::Admin::Builder.create(:test) do
        admin do
          def custom_method
            "Custom"
          end
        end
      end

      expect(::TestAdmin.custom_method).to eq("Custom")
    end
  end

  describe "#controller" do
    it "evaluates the block in the context of the controller" do
      builder = Trestle::Admin::Builder.create(:test)

      expect(::TestAdmin::AdminController).to receive(:before_action).with(:test)

      builder.build do
        controller do
          before_action :test
        end
      end
    end
  end

  describe "#helper" do
    module TestHelper; end

    it "adds the helpers to the controller" do
      builder = Trestle::Admin::Builder.create(:test)

      expect(::TestAdmin::AdminController).to receive(:helper).with(TestHelper)

      builder.build do
        helper TestHelper
      end
    end
  end

  describe "#table" do
    it "builds an index table" do
      Trestle::Admin::Builder.create(:test) do
        table custom: "option" do
          column :test
        end
      end

      expect(::TestAdmin.tables[:index]).to be_a(Trestle::Table)
      expect(::TestAdmin.tables[:index].options).to eq(custom: "option")
      expect(::TestAdmin.tables[:index].columns[0].field).to eq(:test)
    end

    it "builds a named table" do
      Trestle::Admin::Builder.create(:test) do
        table :named, custom: "option" do
          column :test
        end
      end

      expect(::TestAdmin.tables[:named]).to be_a(Trestle::Table)
      expect(::TestAdmin.tables[:named].options).to eq(custom: "option")
      expect(::TestAdmin.tables[:named].columns[0].field).to eq(:test)
    end
  end

  describe "#form" do
    context "with a block" do
      it "builds a custom form" do
        b = Proc.new {}

        Trestle::Admin::Builder.create(:test) do
          form custom: "option", &b
        end

        expect(::TestAdmin.form).to be_a(Trestle::Form)
        expect(::TestAdmin.form.options).to eq(custom: "option")
        expect(::TestAdmin.form.block).to eq(b)
      end
    end

    context "without a block" do
      it "builds an automatic form using the given options" do
        Trestle::Admin::Builder.create(:test) do
          form dialog: true
        end

        expect(::TestAdmin.form).to be_a(Trestle::Form::Automatic)
        expect(::TestAdmin.form.options).to eq(dialog: true)
      end
    end
  end

  describe "#routes" do
    it "sets additional routes on the admin" do
      b = Proc.new {}

      Trestle::Admin::Builder.create(:test) do
        routes &b
      end

      expect(::TestAdmin.additional_routes).to eq([b])
    end

    it "can be called multiple times" do
      a = Proc.new {}
      b = Proc.new {}

      Trestle::Admin::Builder.create(:test) do
        routes &a
        routes &b
      end

      expect(::TestAdmin.additional_routes).to eq([a, b])
    end
  end

  describe "#breadcrumb" do
    it "overrides the default breadcrumb" do
      b = Trestle::Breadcrumb.new("Custom")

      Trestle::Admin::Builder.create(:test) do
        breadcrumb { b }
      end

      expect(::TestAdmin.breadcrumb).to eq(b)
    end

    it "allows the breadcrumb to be disabled" do
      Trestle::Admin::Builder.create(:test) do
        breadcrumb false
      end

      expect(::TestAdmin.breadcrumb).to be_nil
    end
  end

  describe "#hook" do
    it "adds an admin-level hook" do
      b = Proc.new {}

      Trestle::Admin::Builder.create(:test) do
        hook "myhook", {}, &b
      end

      expect(::TestAdmin.hooks.for("myhook")).to eq([Trestle::Hook.new("myhook", {}, &b)])
    end
  end
end
