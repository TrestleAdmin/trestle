require 'spec_helper'

require_relative '../../../app/helpers/trestle/avatar_helper'

describe Trestle::AvatarHelper do
  include Trestle::AvatarHelper

  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Context

  describe "#avatar" do
    let(:image) { content_tag(:img, src: "avatar.png") }

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
