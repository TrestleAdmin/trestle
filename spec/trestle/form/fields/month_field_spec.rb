require 'spec_helper'

require_relative "form_control_examples"

describe Trestle::Form::Fields::MonthField, type: :helper do
  it_behaves_like "a form control", :date, Date.new(2020, 9, 1) do
    subject { builder.month_field(:date, options) }

    it "renders as a month field" do
      expect(subject).to have_tag("input.form-control", with: { type: "month", value: "2020-09" })
    end
  end
end
