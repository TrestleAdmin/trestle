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

      expect(::TestAdmin.collection).to eq([1, 2, 3])
    end
  end

  describe "#instance" do
    it "sets an explicit instance block" do
      Trestle::Resource::Builder.build(:test) do
        instance do |params|
          params[:id]
        end
      end

      expect(::TestAdmin.instance(id: 123)).to eq(123)
    end
  end

  describe "#paginate" do
    it "sets an explicit paginate block" do
      collection = double

      Trestle::Resource::Builder.build(:test) do
        paginate do |collection, params|
          collection.paginate(page: params[:page])
        end
      end

      expect(collection).to receive(:paginate).with(page: 5).and_return([1, 2, 3])
      expect(::TestAdmin.paginate(collection, page: 5)).to eq([1, 2, 3])
    end
  end

  describe "#decorator" do
    it "sets a decorator class" do
      class TestDecorator; end

      Trestle::Resource::Builder.build(:test) do
        decorator TestDecorator
      end

      collection = double
      expect(TestDecorator).to receive(:decorate_collection).with(collection).and_return([1, 2, 3])
      expect(::TestAdmin.decorate(collection)).to eq([1, 2, 3])
    end
  end
end
