require 'spec_helper'

describe Trestle::IconHelper, type: :helper do
  describe "#icon" do
    it "returns an <i> tag with the given classes" do
      result = icon("fas", "fa-star")
      expect(result).to have_tag("i.fas.fa-star")
    end

    it "applies any additional attributes to the <i> tag (merging classes)" do
      result = icon("fas", "fa-star", class: "fa-fw", id: "icon")
      expect(result).to have_tag("i#icon.fas.fa-star.fa-fw")
    end
  end
end
