module Trestle
  module AvatarHelper
    # Renders an avatar (or similar image) styled as a circle typically designed to
    # represent a user (though not limited to that). The avatar helper accepts a block
    # within which the image should be provided, which will be resized to fit.
    #
    # fallback   - Optional short text (2-3 characters) shown when no image is available
    # attributes - Additional HTML attributes to add to the <div> tag
    #
    # Examples
    #
    #   <%= avatar { image_tag("person.jpg") } %>
    #
    #   <%= avatar(fallback: "SP", class: "avatar-lg") { gravatar("sam@trestle.io") } %>
    #
    #   <%= avatar(style: "--avatar-size: 3rem") { gravatar("sam@trestle.io") }
    #
    # Return the HTML div containing the avatar image.
    def avatar(fallback: nil, **attributes, &block)
      tag.div(**default_avatar_options.merge(attributes)) do
        concat tag.span(fallback, class: "avatar-fallback") if fallback
        concat yield if block_given?
      end
    end

  protected
    def default_avatar_options
      Trestle::Options.new(class: ["avatar"])
    end
  end
end
