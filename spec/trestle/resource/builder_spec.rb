require 'spec_helper'

class Trestle::ApplicationController < ActionController::Base; end

describe Trestle::Resource::Builder do
  before(:each) do
    Object.send(:remove_const, :TestAdmin) if Object.const_defined?(:TestAdmin)
  end

  it "creates a top-level Resource subclass" do
    Trestle::Resource::Builder.build(:test)
    expect(::TestAdmin).to be < Trestle::Resource
  end

  it "creates an AdminController class" do
    Trestle::Resource::Builder.build(:test)
    expect(::TestAdmin::AdminController).to be < Trestle::Resource::Controller
    expect(::TestAdmin::AdminController.admin).to eq(::TestAdmin)
  end

  describe "#collection" do
    it "sets an explicit collection block" do
      Trestle::Resource::Builder.build(:test) do
        collection do
          [1, 2, 3]
        end
      end

      expect(::TestAdmin.collection.call).to eq([1, 2, 3])
    end
  end
end
