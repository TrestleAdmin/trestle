require 'spec_helper'

describe Trestle::Form::Builder, type: :helper do
  describe ".register" do
    let(:field) { double }
    let(:field_name) { "Field" }

    it "adds the field to the builder fields hash" do
      Trestle::Form::Builder.register(:test, field)
      expect(Trestle::Form::Builder.fields[:test]).to eq(field)
    end

    it "evaluates proc arguments when accessed" do
      Trestle::Form::Builder.register(:test, -> { field })
      expect(Trestle::Form::Builder.fields[:test]).to eq(field)
    end

    it "does not evaluate proc arguments when added" do
      expect(self).not_to receive(:field)
      Trestle::Form::Builder.register(:test, -> { field })
    end

    it "constantizes string arguments when accessed" do
      Trestle::Form::Builder.register(:test, field_name)

      expect(field_name).to receive(:safe_constantize).and_return(field)
      expect(Trestle::Form::Builder.fields[:test]).to eq(field)
    end
  end
end
