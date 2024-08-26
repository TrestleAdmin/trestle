require 'spec_helper'

describe Trestle::AvatarHelper, type: :helper do
  describe "#avatar" do
    let(:image) { tag.img(src: "avatar.png") }

    it "renders an avatar" do
      result = avatar { image }

      expect(result).to have_tag(".avatar") do
        with_tag "img", src: "avatar.png"
      end
    end

    it "renders a fallback if provided" do
      result = avatar(fallback: "SP") { image }

      expect(result).to have_tag(".avatar") do
        with_tag "span.avatar-fallback", text: "SP"
        with_tag "img", src: "avatar.png"
      end
    end

    it "passes custom option to the div" do
      result = avatar(style: "border: 1px solid red") { image }

      expect(result).to have_tag(".avatar", with: { style: "border: 1px solid red" })
    end
  end
end
