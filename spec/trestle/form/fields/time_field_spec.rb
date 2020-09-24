require 'spec_helper'

require_relative "date_picker_examples"

describe Trestle::Form::Fields::TimeField, type: :helper do
  it_behaves_like "a date picker control", :date, Time.new(2020, 9, 1) do
    subject { builder.time_field(:date, options) }

    let(:icon) { "fa fa-clock-o" }

    it "renders as a time field" do
      expect(subject).to have_tag("input.form-control", with: { type: "time", value: "00:00:00.000" })
    end
  end
end
