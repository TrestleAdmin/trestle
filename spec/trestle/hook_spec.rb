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

    context "with arguments" do
      let(:block) { ->(a, b) { foo(a, b) } }

      it "passes the given arguments to the block" do
        expect(context).to receive(:foo).with(1, 2)
        hook.evaluate(context, 1, 2)
      end
    end
  end
end

describe Trestle::Hook::Set do
  subject(:set) { Trestle::Hook::Set.new }
  let(:block) { -> {} }

  it "is initially empty" do
    expect(set).to be_empty
  end

  describe "#any?" do
    it "returns true if there are hooks with the given name" do
      set.append("hook", {}, &block)
      expect(set.any?("hook")).to be true
    end

    it "returns false if there are no hooks with the given name" do
      expect(set.any?("missing")).to be false
    end
  end

  describe "#for" do
    it "returns the hooks with the given name" do
      set.append("hook", {}, &block)
      expect(set.for("hook")).to eq([Trestle::Hook.new("hook", {}, &block)])
    end

    it "returns an empty array if no hooks are defined" do
      expect(set.for("missing")).to eq([])
    end
  end
end
