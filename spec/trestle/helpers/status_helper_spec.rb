require 'spec_helper'

describe Trestle::StatusHelper, type: :helper do
  describe "#status_tag" do
    it "returns a badge with the given label" do
      result = status_tag("Status")
      expect(result).to have_tag("span.badge.badge-primary", text: "Status")
    end

    it "sets the badge class based on the status if provided" do
      result = status_tag("Warning", :warning)
      expect(result).to have_tag("span.badge.badge-warning", text: "Warning")
    end

    it "applies any additional attributes to the badge (merging classes)" do
      result = status_tag("Status", :info, class: "badge-pill", id: "status")
      expect(result).to have_tag("span#status.badge.badge-info.badge-pill", text: "Status")
    end

    it "applies additional attributes if an explicit status is not provided" do
      result = status_tag("Status", class: "badge-pill", id: "status")
      expect(result).to have_tag("span#status.badge.badge-primary.badge-pill", text: "Status")
    end
  end
end
