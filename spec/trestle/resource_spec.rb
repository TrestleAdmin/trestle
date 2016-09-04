require 'spec_helper'

describe Trestle::Resource do
  before(:each) do
    Object.send(:remove_const, :TestAdmin) if defined?(TestAdmin)
    class TestAdmin < Trestle::Resource; end
  end

  subject(:admin) { TestAdmin }

  it "is a subclass of Admin" do
    expect(admin).to be < Trestle::Admin
  end

  it "infers the model from the admin name" do
    class Test; end
    expect(admin.model).to eq(Test)
  end

  it "allows the model name to be specified manually via options" do
    class AlternateModel; end
    admin.options = { model: AlternateModel }
    expect(admin.model).to eq(AlternateModel)
  end

  context "scoped within a module" do
    before(:each) do
      Scoped.send(:remove_const, :TestAdmin) if defined?(Scoped::TestAdmin)

      module Scoped
        class Test; end
        class TestAdmin < Trestle::Resource; end
      end
    end

    subject(:admin) { Scoped::TestAdmin }

    it "infers the model from the module and admin name" do
      expect(admin.model).to eq(Scoped::Test)
    end
  end
end
