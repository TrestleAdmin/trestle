module Trestle
  module AvatarHelper
    def avatar(options={})
      content_tag(:div, class: "avatar") do
        concat content_tag(:span, options[:fallback], class: "avatar-fallback") if options[:fallback]
        concat yield if block_given?
      end
    end

    def gravatar(email, options={})
      options = { d: "mm" }.merge(options)

      url = "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.to_s.downcase)}.png"
      url << "?#{options.to_query}" if options.any?

      image_tag(url)
    end
  end
end
