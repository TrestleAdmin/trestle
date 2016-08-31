module Trestle
  module AvatarHelper
    def gravatar(email)
      avatar { image_tag("https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.to_s.downcase)}.png") }
    end

    def avatar(&block)
      content_tag(:div, class: "avatar", &block)
    end
  end
end
