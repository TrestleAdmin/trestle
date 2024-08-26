module Trestle
  module GravatarHelper
    # Returns a Gravatar image tag for a given email address.
    # See https://docs.gravatar.com/api/avatars/images/ for available options.
    #
    # In general, this should be wrapped in an avatar block to apply styling.
    # This method is also aliased as `gravatar`.
    #
    # email   - Email address for Gravatar image; will be MD5-hashed to create the URL
    # options - Options to pass to Gravatar API (as query string params)
    #
    # Examples
    #
    # <%= avatar { gravatar_image_tag("sam@trestle.io") } %>
    #
    # <%= avatar { gravatar_image_tag("sam@trestle.io", size: 120, d: "retro") } %>
    #
    # Returns a HTML-safe String.
    def gravatar_image_tag(email, **options)
      image_tag(gravatar_image_url(email, **options))
    end
    alias gravatar gravatar_image_tag

    # Returns a Gravatar image URL for a given email address.
    # See https://docs.gravatar.com/api/avatars/images/ for available options.
    #
    # email   - Email address for Gravatar image; will be MD5-hashed to create the URL
    # options - Options to pass to Gravatar API (as query string params)
    #
    # Example
    #
    # <%= gravatar_image_url("sam@trestle.io", size: 120, d: "retro") %>
    #
    # Returns a HTML-safe String.
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
