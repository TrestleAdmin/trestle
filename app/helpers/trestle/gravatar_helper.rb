module Trestle
  module GravatarHelper
    def gravatar_image_tag(email, **options)
      image_tag(gravatar_image_url(email, **options))
    end
    alias gravatar gravatar_image_tag

    def gravatar_image_url(email, **options)
      options = default_gravatar_options.merge(options)

      url = "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.to_s.downcase)}.png"
      url << "?#{options.to_query}" if options.any?
      url
    end

  protected
    def default_gravatar_options
      { d: "mp" }
    end
  end
end
