module Trestle
  module AvatarHelper
    def avatar(&block)
      content_tag(:div, class: "avatar", &block)
    end

    def gravatar(email)
      image_tag("https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.to_s.downcase)}.png")
    end
  end
end
