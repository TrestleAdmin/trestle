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

    it "passes given attributes to the row div" do
      expect(row(id: "my-row", data: { attr: "value" }) { "content" }).to have_tag(".row", text: "content", with: { id: "my-row", "data-attr": "value" })
    end

    it "adds any extra classes to the row div" do
      expect(row(class: "row-cols-2") { "content" }).to have_tag(".row.row-cols-2", text: "content")
    end
  end

  describe "#col" do
    it "creates a div with class 'col'" do
      expect(col { "content" }).to have_tag(".col", text: "content")
    end

    it "creates a div with the given column count" do
      expect(col(3) { "content" }).to have_tag(".col-3", text: "content", without: { class: "col" })
    end

    it "adds column classes for the given breakpoints" do
      expect(col(3, md: 2, xl: 1) { "content" }).to have_tag(".col-3.col-md-2.col-xl-1", text: "content", without: { class: "col" })
    end

    it "allows the primary column count to be omitted" do
      expect(col(sm: 4, xl: 3) { "content" }).to have_tag(".col-sm-4.col-xl-3", text: "content", without: { class: "col" })
    end

    it "fixes legacy usage of the xs breakpoint" do
      expect(col(xs: 4, md: 3) { "content" }).to have_tag(".col-4.col-md-3", text: "content", without: { class: "col" })
    end
  end

  describe "#divider" do
    it "creates an hr tag" do
      expect(divider).to have_tag("hr")
    end

    it "passes given attributes to the hr tag" do
      expect(divider(class: "custom-hr")).to have_tag("hr.custom-hr")
    end
  end
end
