require 'spec_helper'

#class Trestle::ApplicationController < ActionController::Base; end

describe Trestle::Admin::Builder do
  before(:each) do
    Object.send(:remove_const, :TestAdmin) if Object.const_defined?(:TestAdmin)
    stub_const("Trestle::ApplicationController", Class.new(ActionController::Base))
  end

  it "creates a top-level Admin subclass" do
    Trestle::Admin::Builder.build(:test)
    expect(::TestAdmin).to be < Trestle::Admin
  end

  context "with a module scope" do
    before(:each) do
      module Scoped; end
      Scoped.send(:remove_const, :TestAdmin) if Scoped.const_defined?(:TestAdmin)
    end

    it "creates the Admin subclass within the module scope" do
      Trestle::Admin::Builder.build(:test, scope: Scoped)
      expect(::Scoped::TestAdmin).to be < Trestle::Admin
    end
  end

  it "creates an AdminController class" do
    Trestle::Admin::Builder.build(:test)
    expect(::TestAdmin::AdminController).to be < Trestle::Admin::Controller
    expect(::TestAdmin::AdminController.admin).to eq(::TestAdmin)
  end

  it "transfer the options on the Admin class" do
    options = { custom: "option" }
    Trestle::Admin::Builder.build(:test, options)
    expect(TestAdmin.options).to eq(options)
  end

  describe "#menu" do
    it "sets the admin's menu to a bound navigation block" do
      Trestle::Admin::Builder.build(:test) do
        menu do
        end
      end

      expect(::TestAdmin.menu).to be_a(Trestle::Navigation::Block)
      expect(::TestAdmin.menu.admin).to eq(::TestAdmin)
    end

    it "uses a single-line menu definition if no block provided" do
      Trestle::Admin::Builder.build(:test) do
        menu :test, "/path"
      end

      expect(::TestAdmin.menu.items).to eq([Trestle::Navigation::Item.new(:test, "/path")])
    end
  end

  describe "#admin" do
    it "evaluates the block in the context of the admin" do
      Trestle::Admin::Builder.build(:test) do
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
      builder = Trestle::Admin::Builder.new(:test)

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
      builder = Trestle::Admin::Builder.new(:test)

      expect(::TestAdmin::AdminController).to receive(:helper).with(TestHelper)

      builder.build do
        helper TestHelper
      end
    end
  end

  describe "#table" do
    it "builds a sortable table" do
      Trestle::Admin::Builder.build(:test) do
        table custom: "option" do
          column :test
        end
      end

      expect(::TestAdmin.table).to be_a(Trestle::Table)
      expect(::TestAdmin.table.options).to eq(custom: "option", sortable: true, admin: ::TestAdmin)
      expect(::TestAdmin.table.columns[0].field).to eq(:test)
    end
  end

  describe "#form" do
    it "builds a form" do
      b = Proc.new {}

      Trestle::Admin::Builder.build(:test) do
        form &b
      end

      expect(::TestAdmin.form).to be_a(Trestle::Form)
      expect(::TestAdmin.form.block).to eq(b)
    end
  end

  describe "#routes" do
    it "sets additional routes on the admin" do
      b = Proc.new {}

      Trestle::Admin::Builder.build(:test) do
        routes &b
      end

      expect(::TestAdmin.additional_routes).to eq(b)
    end
  end
end
