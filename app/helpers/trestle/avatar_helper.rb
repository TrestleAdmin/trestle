module Trestle
  module AvatarHelper
    def avatar(options={})
      fallback = options.delete(:fallback) if options[:fallback]

      content_tag(:div, options.reverse_merge(class: "avatar")) do
        concat content_tag(:span, fallback, class: "avatar-fallback") if fallback
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
