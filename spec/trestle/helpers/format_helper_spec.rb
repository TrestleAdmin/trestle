require 'spec_helper'

require_relative '../../../app/helpers/trestle/format_helper'

describe Trestle::FormatHelper do
  include Trestle::FormatHelper

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

    it "formats value as currency" do
      currency = double

      expect(self).to receive(:number_to_currency).with(123.45).and_return(currency)
      expect(format_value(123.45, format: :currency)).to eq(currency)
    end
  end
end
