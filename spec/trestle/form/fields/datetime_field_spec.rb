require 'spec_helper'

require_relative "date_picker_examples"

describe Trestle::Form::Fields::DatetimeField, type: :helper do
  it_behaves_like "a date picker control", :date, Time.new(2020, 9, 1) do
    subject { builder.datetime_field(:date, options) }

    it "renders as a datetime-local field" do
      expect(subject).to have_tag("input.form-control[value^='2020-09-01T00:00:00'][type^='datetime']")
    end

    it "is aliased as #datetime_local_field" do
      expect(builder.datetime_local_field(:date, options)).to eq(subject)
    end
  end
end
