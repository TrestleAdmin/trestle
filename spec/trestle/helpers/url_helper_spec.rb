require 'spec_helper'

describe Trestle::UrlHelper, type: :helper do
  before(:each) do
    Trestle.registry.reset!
  end

  describe "#admin_link_to", remove_const: true do
    let!(:admin) { Trestle.resource(:test, model: model) }

    let(:model) { stub_const("Model", Class.new) }
    let(:current_admin) { admin.new(self) }

    let(:modal_request?) { false }

    before(:each) do
      allow(admin).to receive(:new).with(self).and_return(current_admin)

      allow(current_admin).to receive(:path).and_return("/admin/test")
      allow(current_admin).to receive(:instance_path).and_return("/admin/123")
    end

    context "when a string URL is provided" do
      it "renders a link to the given URL" do
        link = admin_link_to("Link Text", "/url")
        expect(link).to have_tag("a", text: "Link Text", with: { href: "/url" })
      end

      it "passes additional options to the link" do
        link = admin_link_to("Link Text", "/url", class: "btn btn-primary", data: { controller: "modal-trigger" })
        expect(link).to have_tag("a.btn.btn-primary", text: "Link Text", with: { href: "/url", "data-controller": "modal-trigger" })
      end

      it "uses the block as the link content if provided" do
        link = admin_link_to "/url", class: "btn btn-success", data: { controller: "batch-action" } do
          "Link Text from Block"
        end

        expect(link).to have_tag("a.btn.btn-success", text: "Link Text from Block", with: { href: "/url", "data-controller": "batch-action" })
      end
    end

    context "when an instance is provided" do
      let(:instance) { model.new }

      it "generates a link to the show action of the given admin" do
        expect(current_admin).to receive(:instance_path).with(instance, action: :show).and_return("/admin/123")

        link = admin_link_to("Instance Link", instance, admin: :test)
        expect(link).to have_tag("a", text: "Instance Link", with: { href: "/admin/123" })
      end

      it "uses provided action and params" do
        expect(current_admin).to receive(:instance_path).with(instance, action: :edit, tab: :details).and_return("/admin/123/edit?tab=details")

        link = admin_link_to("Instance Link", instance, admin: :test, action: :edit, params: { tab: :details })
        expect(link).to have_tag("a", text: "Instance Link", with: { href: "/admin/123/edit?tab=details" })
      end

      it "passes additional options to the link" do
        link = admin_link_to("Instance Link", instance, admin: :test, class: "btn btn-success", data: { controller: "custom-action" })
        expect(link).to have_tag("a.btn.btn-success", text: "Instance Link", with: { "data-controller": "custom-action" })
      end

      it "falls back to the current admin if not explicitly provided" do
        expect(current_admin).to receive(:instance_path).with(instance, action: :show).and_return("/admin/123")

        link = admin_link_to("Instance Link", instance)
        expect(link).to have_tag("a", text: "Instance Link", with: { href: "/admin/123" })
      end

      it "raises an error if an admin can't be found" do
        expect {
          admin_link_to("Instance Link", instance, admin: :missing)
        }.to raise_exception(ActionController::UrlGenerationError, "An admin could not be inferred. Please specify an admin using the :admin option.")
      end
    end

    context "when no instance is provided" do
      it "generates a link to the index action of the given admin" do
        expect(current_admin).to receive(:path).with(:index, {}).and_return("/admin/test")
        link = admin_link_to("Collection Link", admin: :test)
        expect(link).to have_tag("a", text: "Collection Link", with: { href: "/admin/test" })
      end

      it "uses provided action and params" do
        expect(current_admin).to receive(:path).with(:summary, { scope: :test }).and_return("/admin/test/summary?scope=test")
        link = admin_link_to("Collection Link", admin: :test, action: :summary, params: { scope: :test })
        expect(link).to have_tag("a", text: "Collection Link", with: { href: "/admin/test/summary?scope=test" })
      end

      it "passes additional options to the link" do
        link = admin_link_to("Collection Link", admin: :test, class: "btn btn-success", data: { controller: "batch-action" })
        expect(link).to have_tag("a.btn.btn-success", text: "Collection Link", with: { "data-controller": "batch-action" })
      end

      it "uses the block as the link content if provided" do
        link = admin_link_to admin: :test do
          "Link Text from Block"
        end

        expect(link).to have_tag("a", text: "Link Text from Block", with: { href: "/admin/test" })
      end

      it "falls back to the current admin if not explicitly provided" do
        expect(current_admin).to receive(:path).with(:index, {}).and_return("/admin/test")
        link = admin_link_to("Collection Link")
        expect(link).to have_tag("a", text: "Collection Link", with: { href: "/admin/test" })
      end

      it "raises an error if the given admin can't be found" do
        expect {
          admin_link_to("Instance Link", admin: :missing)
        }.to raise_exception(ActionController::UrlGenerationError, "An admin could not be inferred. Please specify an admin using the :admin option.")
      end
    end

    context "when linking to a form action" do
      let!(:admin) do
        Trestle.resource(:test, model: model) do
          form modal: true
        end
      end

      it "sets data-controller to 'modal-trigger'" do
        link = admin_link_to("Instance Link", model.new)
        expect(link).to have_tag("a", text: "Instance Link", with: { "data-controller": "modal-trigger" })
      end
    end

    it "sets data-turbo-frame to '_top' for a regular request" do
      link = admin_link_to("Admin Link", admin: :test)
      expect(link).to have_tag("a", text: "Admin Link", with: { href: "/admin/test", "data-turbo-frame": "_top" })
    end

    context "from a modal request" do
      let(:modal_request?) { true }

      it "sets data-turbo-frame to 'modal' for a modal request" do
        link = admin_link_to("Admin Link", admin: :test)
        expect(link).to have_tag("a", text: "Admin Link", with: { href: "/admin/test", "data-turbo-frame": "modal" })
      end
    end

    it "sets the data-turbo-method attribute when passed :method option" do
      link = admin_link_to("Admin Link", admin: :test, method: :post)
      expect(link).to have_tag("a", text: "Admin Link", with: { href: "/admin/test", "data-turbo-method": "post" })
    end
  end

  describe "#admin_url_for", remove_const: true do
    let!(:admin) { Trestle.resource(:test) }
    let!(:alternate_admin) { Trestle.admin(:alternate) }

    let(:current_admin) { admin.new(self) }

    before(:each) do
      allow(admin).to receive(:new).with(self).and_return(current_admin)
    end

    context "when given an instance" do
      let!(:admin) { Trestle.resource(:test, model: model) }

      let(:model) { stub_const("Model", Class.new) }
      let(:instance) { model.new }

      it "returns the admin path by delegating to #instance_path on the admin" do
        expect(current_admin).to receive(:instance_path).with(instance, action: :show).and_return("/admin/123")
        expect(admin_url_for(instance)).to eq("/admin/123")
      end

      it "passes the action and any extra params to the #instance_path method" do
        expect(current_admin).to receive(:instance_path).with(instance, action: :edit, tab: "metadata").and_return("/admin/123/edit?tab=metadata")
        expect(admin_url_for(instance, action: :edit, tab: "metadata")).to eq("/admin/123/edit?tab=metadata")
      end

      it "delegates to the #path method on a non-resourceful admin" do
        alternate_instance = alternate_admin.new(self)
        expect(alternate_admin).to receive(:new).with(self).and_return(alternate_instance)
        expect(alternate_instance).to receive(:to_param).with(instance).and_return(123)
        expect(alternate_instance).to receive(:path).with(:show, { id: 123 }).and_return("/alternate/123")
        expect(admin_url_for(instance, admin: :alternate)).to eq("/alternate/123")
      end
    end

    context "when no instance is given" do
      it "returns the path using by delegating to #path on the admin" do
        expect(current_admin).to receive(:path).with(:index, {}).and_return("/admin")
        expect(admin_url_for(action: :index)).to eq("/admin")
      end

      it "returns the path to the index action by default" do
        expect(current_admin).to receive(:path).with(:index, {}).and_return("/admin")
        expect(admin_url_for).to eq("/admin")
      end

      it "passes additional options to the call to #path" do
        expect(current_admin).to receive(:path).with(:index, { scope: :limited }).and_return("/admin?scope=limited")
        expect(admin_url_for(action: :index, scope: :limited)).to eq("/admin?scope=limited")
      end

      it "uses the specified admin when passed as a symbol" do
        expect(alternate_admin).to receive(:path).with(:index, {}).and_return("/alternate")
        expect(admin_url_for(action: :index, admin: :alternate)).to eq("/alternate")
      end

      it "uses the specified admin when passed as a class" do
        expect(alternate_admin).to receive(:path).with(:index, {}).and_return("/alternate")
        expect(admin_url_for(action: :index, admin: alternate_admin)).to eq("/alternate")
      end
    end

    context "when the given admin is not found" do
      it "returns nil by default" do
        expect(admin_url_for(admin: :missing)).to be nil
      end

      it "raises an exception when raise: true passed" do
        expect {
          admin_url_for(admin: :missing, raise: true)
        }.to raise_exception(ActionController::UrlGenerationError, "An admin could not be inferred. Please specify an admin using the :admin option.")
      end
    end
  end

  describe "#admin_for", remove_const: true do
    let!(:admin) { Trestle.resource(:test, model: model) }

    let(:model) { stub_const("Model", Class.new) }

    let(:instance) { model.new }
    let(:unregistered) { double }

    it "looks up the model's admin in the registry" do
      expect(admin_for(instance)).to eq(admin)
    end

    it "returns nil if the model is not found in the registry" do
      expect(admin_for(unregistered)).to be nil
    end
  end
end
