module Trestle
  module AvatarHelper
    def avatar(&block)
      content_tag(:div, class: "avatar", &block)
    end

    def gravatar(email, options={})
      url = "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.to_s.downcase)}.png"
      url << "?#{options.to_query}" if options.any?

      image_tag(url)
    end
  end
end
