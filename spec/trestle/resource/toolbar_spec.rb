require 'spec_helper'

describe Trestle::Resource::Toolbar::Builder do
  include_context "template"

  let(:actions) { [:index, :new, :create, :show, :edit, :update, :destroy] }
  let(:admin) { double(path: "/admin", to_param: double, form: double(dialog?: false), actions: actions) }

  subject(:builder) { Trestle::Resource::Toolbar::Builder.new(template) }

  it "has a list of registered builder methods" do
    expect(builder.builder_methods).to include(:button, :link, :new, :save, :delete, :dismiss, :ok)
  end

  describe "#new" do
    context "when the admin actions includes :new" do
      let(:actions) { [:new] }

      it "returns a new link" do
        expect(admin).to receive(:t).with("buttons.new", default: "New %{model_name}").and_return("New Resource")
        expect(builder.new).to eq(Trestle::Toolbar::Link.new(template, "New Resource", action: :new, style: :light, icon: "fa fa-plus", class: "btn-new-resource"))
      end
    end

    context "when the admin actions does not include :new" do
      let(:actions) { [] }

      it "renders nothing" do
        expect(builder.new).to be_nil
      end
    end
  end

  describe "#save" do
    it "returns a save button" do
      expect(admin).to receive(:t).with("buttons.save", default: "Save %{model_name}").and_return("Save Resource")
      expect(builder.save).to eq(Trestle::Toolbar::Button.new(template, "Save Resource", style: :success))
    end
  end

  describe "#delete" do
    context "when the admin actions includes :destroy" do
      let(:actions) { [:destroy] }
      let(:instance) { double }

      before(:each) do
        allow(template).to receive(:instance).and_return(instance)
      end

      it "returns a delete link" do
        expect(admin).to receive(:t).with("buttons.delete", default: "Delete %{model_name}").and_return("Delete Resource")
        expect(builder.delete).to eq(Trestle::Toolbar::Link.new(template, "Delete Resource", instance, action: :destroy, method: :delete, style: :danger, icon: "fa fa-trash", data: { toggle: "confirm-delete", placement: "bottom" }))
      end
    end

    context "when the admin actions does not include :destroy" do
      let(:actions) { [] }

      it "renders nothing" do
        expect(builder.delete).to be_nil
      end
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

  describe "#save_or_dismiss" do
    context "when the admin actions includes :update" do
      let(:actions) { [:update] }

      it "returns a save button" do
        expect(admin).to receive(:t).with("buttons.save", default: "Save %{model_name}").and_return("Save Resource")
        expect(builder.save_or_dismiss).to eq(Trestle::Toolbar::Button.new(template, "Save Resource", style: :success))
      end
    end

    context "when the admin action does not include :update" do
      let(:actions) { [] }

      context "from a dialog request" do
        before(:each) do
          allow(template).to receive(:dialog_request?).and_return(true)
        end

        it "returns a dismiss dialog button" do
          expect(admin).to receive(:t).with("buttons.ok", default: "OK").and_return("OK")
          expect(builder.save_or_dismiss).to eq(Trestle::Toolbar::Button.new(template, "OK", style: :light, data: { dismiss: "modal" }))
        end
      end

      context "from a non-dialog request" do
        before(:each) do
          allow(template).to receive(:dialog_request?).and_return(false)
        end

        it "renders nothing" do
          expect(builder.save_or_dismiss).to be_nil
        end
      end
    end

    context "when a custom action is specified" do
      let(:actions) { [:create] }

      it "uses the given action to check whether to show a save button" do
        expect(admin).to receive(:t).with("buttons.save", default: "Save %{model_name}").and_return("Save Resource")
        expect(builder.save_or_dismiss(:create)).to eq(Trestle::Toolbar::Button.new(template, "Save Resource", style: :success))
      end
    end
  end
end
