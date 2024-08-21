require 'spec_helper'

require_relative '../../../app/helpers/trestle/card_helper'

describe Trestle::TimestampHelper do
  include Trestle::TimestampHelper

  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TranslationHelper

  describe "#timestamp" do
    let(:time) { Time.zone.local(2024, 8, 21, 12, 34, 56) }

    it "returns nil if time given is nil" do
      expect(timestamp(nil)).to be_nil
    end

    it "returns a <time> tag with the given time", tz: "Australia/Perth" do
      result = timestamp(time)

      expect(result).to have_tag("time.timestamp", with: { datetime: "2024-08-21T12:34:56+08:00" }) do
        with_tag "span", text: "21st Aug 2024"
        with_tag "small", text: "12:34 PM"
      end
    end

    it "applies any additional attributes to the <time> tag (merging classes)" do
      result = timestamp(time, id: "special-time", class: "timestamp-inline")
      expect(result).to have_tag("time#special-time.timestamp.timestamp-inline")
    end

    it "renders the time with seconds if precision: :seconds is passed" do
      result = timestamp(time, precision: :seconds)

      expect(result).to have_tag("time.timestamp") do
        with_tag "small", text: "12:34:56 PM"
      end
    end

    it "accepts custom date and time formats" do
      result = timestamp(time, date_format: "%B %d, %Y", time_format: "%H:%M")

      expect(result).to have_tag("time.timestamp") do
        with_tag "span", text: "August 21, 2024"
        with_tag "small", text: "12:34"
      end
    end
  end

  describe "#datestamp" do
    let(:date) { Date.new(2024, 8, 21) }

    it "returns nil if date given is nil" do
      expect(datestamp(nil)).to be_nil
    end

    it "returns a <time> tag with the given date" do
      result = datestamp(date)
      expect(result).to have_tag("time.datestamp", text: "8/21/2024", with: { datetime: "2024-08-21" })
    end

    it "applies any additional attributes to the <time> tag (merging classes)" do
      result = datestamp(date, id: "special-date", class: "custom-datestamp")
      expect(result).to have_tag("time#special-date.datestamp.custom-datestamp")
    end

    it "accepts a custom l10n format" do
      result = datestamp(date, format: :long)
      expect(result).to have_tag("time.datestamp", text: "August 21, 2024")
    end
  end
end
