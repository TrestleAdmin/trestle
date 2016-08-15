require 'spec_helper'

class Trestle::ApplicationController < ActionController::Base; end

describe Trestle::AdminBuilder do
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
    module Scoped; end

    it "creates the Admin subclass within the module scope" do
      Trestle::AdminBuilder.new(:test, scope: Scoped)
      expect(::Scoped::TestAdmin).to be < Trestle::Admin
    end
  end
end
