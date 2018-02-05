require 'spec_helper'

require_relative '../../../app/helpers/trestle/format_helper'

describe Trestle::FormatHelper do
  include Trestle::FormatHelper

  before(:each) do
    allow(self).to receive(:truncate) { |v| v }
  end

  describe "#format_value" do
    it "automatically formats timestamp values" do
      time = Time.now
      timestamp = double

      expect(self).to receive(:timestamp).with(time).and_return(timestamp)
      expect(format_value(time)).to eq(timestamp)
    end

    it "automatically formats date values" do
      date = Date.today
      datestamp = double

      expect(self).to receive(:datestamp).with(date).and_return(datestamp)
      expect(format_value(date)).to eq(datestamp)
    end

    it "returns 'none' text for nil values" do
      blank = double

      expect(self).to receive(:content_tag).with(:span, "None", class: "blank").and_return(blank)
      expect(format_value(nil)).to eq(blank)
    end

    it "returns custom blank text when :blank String option provided" do
      blank = double

      expect(self).to receive(:content_tag).with(:span, "Empty", class: "blank").and_return(blank)
      expect(format_value(nil, blank: "Empty")).to eq(blank)
    end

    it "calls custom blank block when :blank option is callable" do
      blank = double

      expect(self).to receive(:icon).with("fa fa-ban").and_return(blank)
      expect(format_value(nil, blank: -> { icon("fa fa-ban") })).to eq(blank)
    end

    it "automatically formats true values" do
      status = double
      icon = double

      expect(self).to receive(:icon).with("fa fa-check").and_return(icon)
      expect(self).to receive(:status_tag).with(icon, :success).and_return(status)
      expect(format_value(true)).to eq(status)
    end

    it "leaves false values empty" do
      expect(format_value(false)).to be_nil
    end

    it "calls display for model-like values" do
      representation = double
      model = double(id: "123")

      expect(self).to receive(:display).with(model).and_return(representation)
      expect(format_value(model)).to eq(representation)
    end

    it "automatically formats array values" do
      list, items = double, double
      first_item, second_item = double, double

      expect(self).to receive(:content_tag).with(:li, "First").and_return(first_item)
      expect(self).to receive(:content_tag).with(:li, "Second").and_return(second_item)
      expect(self).to receive(:safe_join).with([first_item, second_item], "\n").and_return(items)
      expect(self).to receive(:content_tag).with(:ol, items).and_return(list)
      expect(format_value(["First", "Second"])).to eq(list)
    end

    it "formats value as currency" do
      currency = double

      expect(self).to receive(:number_to_currency).with(123.45).and_return(currency)
      expect(format_value(123.45, format: :currency)).to eq(currency)
    end

    it "formats values as tags" do
      tags = double
      first_tag, second_tag = double, double

      expect(self).to receive(:content_tag).with(:span, "First", class: "tag").and_return(first_tag)
      expect(self).to receive(:content_tag).with(:span, "Second", class: "tag").and_return(second_tag)
      expect(self).to receive(:safe_join).with([first_tag, second_tag]).and_return(tags)
      expect(format_value(["First", "Second"], format: :tags)).to eq(tags)
    end
  end
end
