module Trestle
  module AvatarHelper
    def avatar(fallback: nil, **attributes)
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
