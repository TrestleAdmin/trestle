require 'spec_helper'

describe Trestle::Resource do
  before(:each) do
    Object.send(:remove_const, :TestAdmin) if Object.const_defined?(:TestAdmin)
    class TestAdmin < Trestle::Resource; end
  end

  let(:subject) { TestAdmin }

  it "is a subclass of Admin" do
    expect(subject).to be < Trestle::Admin
  end
end
