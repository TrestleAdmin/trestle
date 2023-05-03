require 'spec_helper'

describe Trestle::Color do
  subject(:color) { Trestle::Color.new(124, 199, 90) }

  it "has accessors for each individual RGB component" do
    expect(color.r).to eq(124)
    expect(color.g).to eq(199)
    expect(color.b).to eq(90)
  end

  describe "#rgb" do
    it "returns the rgb values as an array" do
      expect(color.rgb).to eq([124, 199, 90])
    end
  end

  describe "#hsl" do
    it "converts the color to HSL, returning the values as an array" do
      expect(color.hsl).to eq([101, 49, 57])
    end
  end

  describe ".parse" do
    it "parses a 3-digit hex code" do
      color = Trestle::Color.parse("#abc")
      expect(color.rgb).to eq([170, 187, 204])
    end

    it "parses a 6-digit hex code" do
      color = Trestle::Color.parse("#9bbe7e")
      expect(color.rgb).to eq([155, 190, 126])
    end

    it "parses an rgb value" do
      color = Trestle::Color.parse("rgb(68, 163, 181)")
      expect(color.rgb).to eq([68, 163, 181])
    end

    it "parses a hsl value" do
      color = Trestle::Color.parse("hsl(199, 55, 40)")
      expect(color.rgb).to eq([46, 123, 158])
    end
  end
end
