require 'spec_helper'

require_relative '../../../app/helpers/trestle/navigation_helper'

describe Trestle::NavigationHelper do
  include Trestle::NavigationHelper

  describe "#current_admin?" do
    context "when admin is undefined" do
      it "returns false" do
        expect(current_admin?(double)).to be_falsy
      end
    end

    context "when admin is nil" do
      let(:admin) { nil }

      it "returns false" do
        expect(current_admin?(double)).to be_falsy
      end
    end
  end

  context "when admin is defined" do
    let(:admin) { double(name: "myadmin") }

    it "returns true if the admin's name matches" do
      expect(current_admin?(double(name: "myadmin"))).to be true
    end

    it "returns false if the admin's name does not match" do
      expect(current_admin?(double(name: "another"))).to be_falsy
    end
  end
end
