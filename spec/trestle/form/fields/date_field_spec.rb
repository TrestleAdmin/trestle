require 'spec_helper'

require_relative "date_picker_examples"

describe Trestle::Form::Fields::DateField, type: :helper do
  it_behaves_like "a date picker control", :date, Date.new(2020, 9, 1) do
    subject { builder.date_field(:date, options) }

    it "renders as a date field" do
      expect(subject).to have_tag("input.form-control", with: { type: "date", value: "2020-09-01" })
    end
  end
end
