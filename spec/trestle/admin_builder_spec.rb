require 'spec_helper'

class Trestle::ApplicationController < ActionController::Base; end

describe Trestle::AdminBuilder do
  before(:each) do
    Object.send(:remove_const, :TestAdmin) if Object.const_defined?(:TestAdmin)
  end

  it "creates a top-level Admin subclass" do
    Trestle::AdminBuilder.new(:test)
    expect(::TestAdmin).to be < Trestle::Admin
  end

  it "creates an AdminController class" do
    Trestle::AdminBuilder.new(:test)
    expect(::TestAdmin::AdminController).to be < Trestle::AdminController
    expect(::TestAdmin::AdminController.admin).to eq(::TestAdmin)
  end

  context "with a module scope" do
    before(:each) do
      module Scoped; end
      Scoped.send(:remove_const, :TestAdmin) if Scoped.const_defined?(:TestAdmin)
    end

    it "creates the Admin subclass within the module scope" do
      Trestle::AdminBuilder.new(:test, scope: Scoped)
      expect(::Scoped::TestAdmin).to be < Trestle::Admin
    end
  end
end
