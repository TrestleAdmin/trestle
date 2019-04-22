require 'spec_helper'

require_relative '../../../app/helpers/trestle/grid_helper'

describe Trestle::GridHelper do
  include Trestle::GridHelper

  include ActionView::Helpers::TagHelper
  include ActionView::Context

  describe "#row" do
    it "creates a div with class 'row'" do
      expect(row { "content" }).to have_tag(".row", text: "content")
    end
  end

  describe "#col" do
    it "creates a div with class 'col'" do
      expect(col { "content" }).to have_tag(".col", text: "content")
    end

    it "creates a div with the given column count" do
      expect(col(3) { "content" }).to have_tag(".col-3", text: "content")
    end

    it "adds column classes for the given breakpoints" do
      expect(col(3, md: 2, xl: 1) { "content"}).to have_tag(".col-3.col-md-2.col-xl-1", text: "content")
    end

    it "allows the primary column count to be omitted" do
      expect(col(sm: 4, xl: 3) { "content"}).to have_tag(".col.col-sm-4.col-xl-3", text: "content")
    end

    it "fixes legacy usage of the xs breakpoint" do
      expect(col(xs: 4, md: 3) { "content"}).to have_tag(".col-4.col-md-3", text: "content")
    end
  end
end
