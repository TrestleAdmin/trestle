require 'spec_helper'

require_relative "form_control_examples"

describe Trestle::Form::Fields::WeekField, type: :helper do
  it_behaves_like "a form control", :date, Date.new(2020, 9, 1) do
    subject { builder.week_field(:date, options) }

    it "renders as a week field" do
      expect(subject).to have_tag("input.form-control", with: { type: "week", value: "2020-W36" })
    end
  end
end
