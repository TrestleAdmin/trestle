require 'spec_helper'

describe Trestle::Hook do
  subject(:hook) { Trestle::Hook.new("hook", {}, &block) }
  let(:block) { -> {} }

  it "is visible by default" do
    expect(hook.visible?(self)).to be true
  end

  it "is not visible if options[:if] is provided and evaluates to false" do
    hook = Trestle::Hook.new("hook", if: -> { false }, &block)
    expect(hook.visible?(self)).to be false
  end

  it "is not visible if options[:unless] if provided and evaluates to true" do
    hook = Trestle::Hook.new("hook", unless: -> { true }, &block)
    expect(hook.visible?(self)).to be false
  end

  describe "#evaluate" do
    let(:block) { -> { foo } }
    let(:context) { double }

    it "evaluates the block in the given context" do
      expect(context).to receive(:foo)
      hook.evaluate(context)
    end
  end
end
