require 'spec_helper'

require_relative '../../../app/helpers/trestle/url_helper'

describe Trestle::UrlHelper do
  include Trestle::UrlHelper

  let(:form) { double(dialog?: false) }
  let(:admin) { double(form: form) }

  before(:each) do
    allow(Trestle).to receive(:lookup).and_return(nil)
    allow(Trestle).to receive(:lookup).with(admin).and_return(admin)
  end

  describe "#admin_link_to" do
    let(:url) { double }
    let(:link) { double }

    context "when a string URL is provided" do
      let(:url) { "/test" }

      it "renders a link to the given URL" do
        expect(self).to receive(:link_to).with("link content", url, {}).and_return(link)
        expect(admin_link_to("link content", url)).to eq(link)
      end
    end

    context "when an instance is provided" do
      let(:instance) { double(id: 123) }

      before(:each) do
        expect(admin).to receive(:to_param).with(instance).and_return(123)
        expect(admin).to receive(:path).with(:show, id: 123).and_return(url)
        expect(self).to receive(:admin_for).with(instance).and_return(admin)
      end

      it "renders a link to the given instance" do
        expect(self).to receive(:link_to).with("link content", url, {}).and_return(link)
        expect(admin_link_to("link content", instance)).to eq(link)
      end

      it "passes additional options to link_to" do
        expect(self).to receive(:link_to).with("link content", url, class: "btn").and_return(link)
        expect(admin_link_to("link content", instance, class: "btn")).to eq(link)
      end

      it "uses the block as content if provided" do
        blk = Proc.new {}

        expect(self).to receive(:capture) { |&block|
          expect(block).to be(blk)
        }.and_return("captured content")

        expect(self).to receive(:link_to).with("captured content", url, {}).and_return(link)
        expect(admin_link_to(instance, &blk)).to eq(link)
      end

      context "target admin's form is a dialog" do
        let(:form) { double(dialog?: true) }

        it "renders the admin link with data-behavior='dialog' set" do
          expect(self).to receive(:link_to).with("link content", url, { data: { behavior: "dialog" } }).and_return(link)
          expect(admin_link_to("link content", instance)).to eq(link)
        end
      end
    end

    context "when no instance is provided" do
      it "renders a link using the given admin, action and params" do
        expect(Trestle).to receive(:lookup).with(:test).and_return(admin)
        expect(admin).to receive(:path).with(:new, foo: "bar").and_return(url)
        expect(self).to receive(:link_to).with("link content", url, {}).and_return(link)
        expect(admin_link_to("link content", action: :new, admin: :test, params: { foo: "bar" })).to eq(link)
      end

      context "target admin's form is a dialog" do
        let(:form) { double(dialog?: true) }

        it "renders the admin link with data-behavior='dialog' set" do
          expect(Trestle).to receive(:lookup).with(:test).and_return(admin)
          expect(admin).to receive(:path).with(:new, foo: "bar").and_return(url)
          expect(self).to receive(:link_to).with("link content", url, { data: { behavior: "dialog" } }).and_return(link)
          expect(admin_link_to("link content", action: :new, admin: :test, params: { foo: "bar" })).to eq(link)
        end
      end
    end

    context "when no admin or instance is provided" do
      it "uses the current admin" do
        expect(admin).to receive(:path).with(:new, {}).and_return(url)
        expect(self).to receive(:link_to).with("link content", url, {}).and_return(link)
        expect(admin_link_to("link content", action: :new)).to eq(link)
      end

      context "no current admin" do
        let(:admin) { nil }

        it "raises an exception" do
          expect {
            admin_link_to("link content", action: :new)
          }.to raise_exception(ActionController::UrlGenerationError, "An admin could not be inferred. Please specify an admin using the :admin option.")
        end
      end
    end
  end

  describe "#admin_url_for" do
    let(:instance) { double }
    let(:param) { double }

    it "returns the path to the show action of the given admin and instance" do
      expect(admin).to receive(:to_param).with(instance).and_return(param)
      expect(admin).to receive(:path).with(:show, id: param)
      admin_url_for(instance, admin: admin)
    end

    it "returns nil if the admin passed is nil" do
      expect(admin_url_for(instance)).to be_nil
    end
  end

  describe "#admin_for" do
    let(:model) { stub_const("Model", Class.new) }
    let(:instance) { model.new }

    before(:each) do
      allow(Trestle).to receive(:lookup_model).with(model).and_return(admin)
    end

    it "looks up the model's admin in the registry" do
      expect(admin_for(instance)).to eq(admin)
    end
  end
end
