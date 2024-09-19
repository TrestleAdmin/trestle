require 'spec_helper'

describe Trestle::ModalHelper, type: :helper do
  describe "#modal_options!" do
    it "merges hash with existing modal options" do
      modal_options!(class: "modal-class")
      modal_options!(id: "modal-id", controller: "modal-controller")

      expect(modal_options).to eq({
        class: "modal-class",
        id: "modal-id",
        controller: "modal-controller"
      })
    end
  end

  describe "#modal_wrapper_attributes" do
    it "returns core HTML attributes for the modal wrapper element" do
      expect(modal_wrapper_attributes).to eq({
        class: ["modal", "fade"],
        tabindex: "-1",
        role: "dialog",
        data: { controller: "modal" }
      })
    end

    it "merges the wrapper class and id from modal_options if provided" do
      modal_options!(wrapper_class: "custom-modal", id: "custom-modal-id")

      expect(modal_wrapper_attributes).to eq({
        class: ["modal", "fade", "custom-modal"],
        tabindex: "-1",
        role: "dialog",
        data: { controller: "modal" },
        id: "custom-modal-id"
      })
    end

    it "merges the controller from modal_options if provided" do
      modal_options!(controller: "custom-modal")

      expect(modal_wrapper_attributes).to eq({
        class: ["modal", "fade"],
        tabindex: "-1",
        role: "dialog",
        data: { controller: "modal custom-modal" }
      })
    end
  end

  describe "#modal_dialog_attributes" do
    it "returns core HTML attributes for the modal-dialog element" do
      expect(modal_dialog_attributes).to eq({ class: ["modal-dialog"], role: "document" })
    end

    it "merges the class from modal_options if provided" do
      modal_options!(class: "modal-lg")
      expect(modal_dialog_attributes).to eq({ class: ["modal-dialog", "modal-lg"], role: "document" })
    end
  end
end
