require 'spec_helper'

describe Trestle::Resource::Toolbar::Builder do
  include_context "template"

  let(:admin) { double(path: "/admin", to_param: double, form: double(dialog?: false)) }

  subject(:builder) { Trestle::Resource::Toolbar::Builder.new(template) }

  it "has a list of registered builder methods" do
    expect(builder.builder_methods).to include(:button, :link, :new, :save, :delete, :dismiss, :ok)
  end

  describe "#new" do
    it "returns a new link" do
      expect(admin).to receive(:t).with("buttons.new", default: "New %{model_name}").and_return("New Resource")
      expect(builder.new).to eq(Trestle::Toolbar::Link.new(template, "New Resource", action: :new, style: :light, icon: "fa fa-plus", class: "btn-new-resource"))
    end
  end

  describe "#save" do
    it "returns a save button" do
      expect(admin).to receive(:t).with("buttons.save", default: "Save %{model_name}").and_return("Save Resource")
      expect(builder.save).to eq(Trestle::Toolbar::Button.new(template, "Save Resource", style: :success))
    end
  end

  describe "#delete" do
    let(:instance) { double }

    before(:each) do
      allow(template).to receive(:instance).and_return(instance)
    end

    it "returns a delete link" do
      expect(admin).to receive(:t).with("buttons.delete", default: "Delete %{model_name}").and_return("Delete Resource")
      expect(builder.delete).to eq(Trestle::Toolbar::Link.new(template, "Delete Resource", instance, action: :destroy, method: :delete, style: :danger, icon: "fa fa-trash", data: { toggle: "confirm-delete", placement: "bottom" }))
    end
  end

  describe "#dismiss" do
    context "from a dialog request" do
      before(:each) do
        allow(template).to receive(:dialog_request?).and_return(true)
      end

      it "returns a dismiss dialog button" do
        expect(admin).to receive(:t).with("buttons.ok", default: "OK").and_return("OK")
        expect(builder.dismiss).to eq(Trestle::Toolbar::Button.new(template, "OK", style: :light, data: { dismiss: "modal" }))
      end

      it "is aliased as #ok" do
        expect(admin).to receive(:t).with("buttons.ok", default: "OK").and_return("OK").twice
        expect(builder.ok).to eq(builder.dismiss)
      end
    end

    context "from a non-dialog request" do
      before(:each) do
        allow(template).to receive(:dialog_request?).and_return(false)
      end

      it "renders nothing" do
        expect(builder.dismiss).to be_nil
      end
    end
  end
end
