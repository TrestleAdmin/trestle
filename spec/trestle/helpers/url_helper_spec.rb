require 'spec_helper'

require_relative '../../../app/helpers/trestle/url_helper'

describe Trestle::UrlHelper do
  include Trestle::UrlHelper

  let(:admin) { double }

  before(:each) do
    allow(Trestle).to receive(:lookup).with(admin).and_return(admin)
  end

  describe "#admin_link_to" do
    let(:instance) { double }
    let(:url) { double }
    let(:link) { double }

    it "renders an admin link to the given instance" do
      expect(self).to receive(:admin_url_for).with(instance, admin: admin).and_return(url)
      expect(self).to receive(:link_to).with("link content", url, {}).and_return(link)
      expect(admin_link_to("link content", instance, admin: admin)).to eq(link)
    end

    it "uses the block as content if provided" do
      blk = Proc.new {}

      expect(self).to receive(:capture) { |&block|
        expect(block).to be(blk)
      }.and_return("captured content")

      expect(self).to receive(:admin_url_for).with(instance, admin: admin).and_return(url)
      expect(self).to receive(:link_to).with("captured content", url, {}).and_return(link)
      expect(admin_link_to(instance, admin: admin, &blk)).to eq(link)
    end

    context "no admin specified" do
      let(:instance) { double }

      it "renders the content unlinked if no admin specified or available" do
        expect(admin_link_to("link content", instance)).to eq("link content")
      end

      it "renders the block content if provided" do
        blk = Proc.new {}

        expect(self).to receive(:capture) { |&block|
          expect(block).to be(blk)
        }.and_return("captured content")

        expect(admin_link_to(instance, &blk)).to eq("captured content")
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
    let(:instance) { double(class: double(name: "MyClass")) }

    it "returns the admin associated with an object's class type" do
      expect(Trestle).to receive(:admins).and_return({ "my_classes" => admin})
      expect(admin_for(instance)).to eq(admin)
    end
  end
end
