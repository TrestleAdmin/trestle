require 'spec_helper'

describe Trestle::Options do
  subject(:options) { Trestle::Options.new }

  it "is a hash" do
    expect(options).to be_a(Hash)
  end

  describe "#merge" do
    it "overrides singular values" do
      options = Trestle::Options.new(singular: "original")
      expect(options.merge(singular: "changed")).to eq(Trestle::Options.new(singular: "changed"))
    end

    it "appends arrays to array values" do
      options = Trestle::Options.new(array: [1, 2, 3])
      expect(options.merge(array: [4, 5, 6])).to eq(Trestle::Options.new(array: [1, 2, 3, 4, 5, 6]))
    end

    it "appends singular values to array values" do
      options = Trestle::Options.new(array: [1, 2, 3])
      expect(options.merge(array: 4)).to eq(Trestle::Options.new(array: [1, 2, 3, 4]))
    end

    it "merges nested hashes" do
      options = Trestle::Options.new(hash: { a: 123, b: "456" })
      expect(options.merge(hash: { b: "abc", c: "def" })).to eq(Trestle::Options.new(hash: { a: 123, b: "abc", c: "def" }))
    end
  end

  describe "#merge!" do
    it "overrides singular values" do
      options = Trestle::Options.new(singular: "original")
      options.merge!(singular: "changed")

      expect(options).to eq(Trestle::Options.new(singular: "changed"))
    end

    it "appends arrays to array values" do
      options = Trestle::Options.new(array: [1, 2, 3])
      options.merge!(array: [4, 5, 6])

      expect(options).to eq(Trestle::Options.new(array: [1, 2, 3, 4, 5, 6]))
    end

    it "appends singular values to array values" do
      options = Trestle::Options.new(array: [1, 2, 3])
      options.merge!(array: 4)

      expect(options).to eq(Trestle::Options.new(array: [1, 2, 3, 4]))
    end

    it "merges nested hashes" do
      options = Trestle::Options.new(hash: { a: 123, b: "456" })
      options.merge!(hash: { b: "abc", c: "def" })

      expect(options).to eq(Trestle::Options.new(hash: { a: 123, b: "abc", c: "def" }))
    end
  end
end
