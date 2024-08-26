require 'spec_helper'

describe Trestle::GravatarHelper, type: :helper do
  let(:email) { "sam@trestle.io" }

  describe "#gravatar_image_tag" do
    it "returns an image tag using the Gravatar URL for the given email" do
      expect(gravatar_image_tag(email)).to have_tag("img", with: { src: "https://www.gravatar.com/avatar/b83de56aa24349d584baf052299494f1.png?d=mp" })
    end

    it "passes options to the gravatar_image_url helper" do
      expect(gravatar_image_tag(email, size: 100, d: "retro")).to have_tag("img", with: { src: "https://www.gravatar.com/avatar/b83de56aa24349d584baf052299494f1.png?d=retro&size=100" })
    end

    it "is aliased as #gravatar" do
      expect(gravatar(email)).to eq(gravatar_image_tag(email))
    end
  end

  describe "#gravatar_image_url" do
    it "returns the Gravatar URL for the given email" do
      expect(gravatar_image_url(email)).to eq("https://www.gravatar.com/avatar/b83de56aa24349d584baf052299494f1.png?d=mp")
    end

    it "appends options as query params" do
      expect(gravatar_image_url(email, size: 100, d: "retro")).to eq("https://www.gravatar.com/avatar/b83de56aa24349d584baf052299494f1.png?d=retro&size=100")
    end
  end
end
