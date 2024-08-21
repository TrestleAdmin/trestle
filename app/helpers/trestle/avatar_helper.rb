module Trestle
  module AvatarHelper
    def avatar(fallback: nil, **attributes)
      tag.div(**default_avatar_options.merge(attributes)) do
        concat tag.span(fallback, class: "avatar-fallback") if fallback
        concat yield if block_given?
      end
    end

    def gravatar(email, options={})
      options = { d: "mp" }.merge(options)

      url = "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.to_s.downcase)}.png"
      url << "?#{options.to_query}" if options.any?

      image_tag(url)
    end

    def default_avatar_options
      Trestle::Options.new(class: ["avatar"])
    end
  end
end
