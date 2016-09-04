require 'spec_helper'

class Trestle::ApplicationController < ActionController::Base; end

describe Trestle::Admin::Builder do
  before(:each) do
    Object.send(:remove_const, :TestAdmin) if Object.const_defined?(:TestAdmin)
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
end
