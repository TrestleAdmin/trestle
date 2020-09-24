require_relative "form_control_examples"

RSpec.shared_examples "a date picker control" do |field, value|
  it_behaves_like "a form control", field, value

  include_context "form", field, value

  let(:icon) { "fa fa-calendar" }

  let(:data_attributes) {
    {
      "data-picker" => true,
      "data-allow-clear" => true
    }
  }

  it "prepends an icon to the input group" do
    expect(subject).to have_tag('.input-group') do
      with_tag "div.input-group-prepend" do
        with_tag(:i, with: { class: icon })
      end
    end
  end

  it "adds the picker data attributes" do
    expect(subject).to have_tag('.form-control', with: data_attributes)
  end

  context "when options[:disabled] is set to true" do
    let(:options) { { disabled: true } }

    it "does not add the picker data attributes" do
      expect(subject).to have_tag('.form-control', without: data_attributes)
    end
  end

  context "when options[:readonly] is set to true" do
    let(:options) { { readonly: true } }

    it "does not add the picker data attributes" do
      expect(subject).to have_tag('.form-control', without: data_attributes)
    end
  end

  context "when options[:picker] is set to false" do
    let(:options) { { picker: false } }

    it "does not add the picker data attributes" do
      expect(subject).to have_tag('.form-control', without: data_attributes)
    end
  end
end
