require 'spec_helper'

describe Trestle::FormatHelper, type: :helper do
  include Trestle::DisplayHelper
  include Trestle::IconHelper
  include Trestle::StatusHelper
  include Trestle::TimestampHelper

  describe "#format_value" do
    describe "autoformatting" do
      it "automatically formats timestamp values" do
        time = Time.now
        expect(format_value(time)).to eq(timestamp(time))
      end

      it "automatically formats date values" do
        date = Date.today
        expect(format_value(date)).to eq(datestamp(date))
      end

      it "returns 'none' text for nil values" do
        result = format_value(nil)
        expect(result).to have_tag("span.blank", text: "None")
      end

      it "returns custom blank text when :blank String option provided" do
        result = format_value(nil, blank: "Empty")
        expect(result).to have_tag("span.blank", text: "Empty")
      end

      it "calls custom blank block when :blank option is callable" do
        result = format_value(nil, blank: -> { icon("fa fa-ban") })
        expect(result).to have_tag("i.fa.fa-ban")
      end

      it "automatically formats true values" do
        expect(format_value(true)).to eq(status_tag(icon("fa fa-check"), :success))
      end

      it "leaves false values empty" do
        expect(format_value(false)).to be_nil
      end

      it "calls display for model-like values" do
        model = double(id: "123", display_name: "Display 123")
        expect(format_value(model)).to eq("Display 123")
      end

      it "automatically formats array values" do
        result = format_value(["First", "Second"])

        expect(result).to have_tag("ol") do
          with_tag "li", text: "First"
          with_tag "li", text: "Second"
        end
      end
    end

    it "formats value as currency with format: :currency" do
      expect(format_value(123.45, format: :currency)).to eq("$123.45")
    end

    it "formats values as tags with format: :tags" do
      result = format_value(["First", "Second"], format: :tags)

      expect(result).to have_tag("div.tag-list") do
        with_tag "span.tag.tag-primary", text: "First"
        with_tag "span.tag.tag-primary", text: "Second"
      end
    end

    it "raises ArgumentError with an invalid format" do
      expect {
        format_value(123, format: :invalid)
      }.to raise_error(ArgumentError, "unknown format: invalid")
    end
  end
end
