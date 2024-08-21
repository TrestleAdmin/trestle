require 'spec_helper'

require_relative '../../../app/helpers/trestle/card_helper'

describe Trestle::CardHelper do
  include Trestle::CardHelper

  include ActionView::Helpers::TagHelper

  describe "#card" do
    it "returns a .card <div> containing a .card-body" do
      result = card { "Content" }

      expect(result).to have_tag("div.card") do
        with_tag "div.card-body", text: "Content"
      end
    end

    it "applies any additional attributes to the .card <div> tag (merging classes)" do
      result = card(id: "mycard", class: "text-bg-primary") { "Content" }

      expect(result).to have_tag("div#mycard.card.text-bg-primary") do
        with_tag "div.card-body", text: "Content"
      end
    end

    it "prepends a header if supplied" do
      result = card(header: "Header Text")

      expect(result).to have_tag("div.card") do
        with_tag "div.card-header", text: "Header Text"
      end
    end

    it "appends a footer if supplied" do
      result = card(footer: "Footer Text")

      expect(result).to have_tag("div.card") do
        with_tag "div.card-footer", text: "Footer Text"
      end
    end
  end
end
