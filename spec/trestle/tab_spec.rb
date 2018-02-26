require 'spec_helper'

describe Trestle::Tab do
  subject(:tab) { Trestle::Tab.new(:my_tab) }

  describe "#id" do
    it "returns the tab id" do
      expect(tab.id).to eq("tab-my_tab")
    end

    it "inserts the tag if provided" do
      expect(tab.id("tag")).to eq("tab-tag-my_tab")
    end
  end

  describe "#label" do
    it "returns the titleized name by default" do
      expect(tab.label).to eq("My Tab")
    end

    it "can be overridden via options" do
      tab = Trestle::Tab.new(:my_tab, label: "Custom Label")
      expect(tab.label).to eq("Custom Label")
    end

    it "returns the badge if set" do
      tab = Trestle::Tab.new(:my_tab, badge: "*")
      expect(tab.label).to eq('My Tab <span class="badge">*</span>')
    end
  end

  describe "#badge" do
    it "does not have a badge by default" do
      expect(tab.badge).to be_blank
    end

    it "returns a badge span tag if the badge option is set" do
      tab = Trestle::Tab.new(:my_tab, badge: 123)
      expect(tab.badge).to eq('<span class="badge">123</span>')
    end
  end
end
