module Trestle
  module TitleHelper
    def trestle_title
      if Trestle.config.site_logo
        if Trestle.config.site_logo_small
          safe_join([
            image_tag(Trestle.config.site_logo, class: "visible-xs-inline visible-lg-inline", alt: Trestle.config.site_title),
            image_tag(Trestle.config.site_logo_small, class: "visible-sm-inline visible-md-inline", alt: Trestle.config.site_title)
          ], "\n")
        else
          image_tag(Trestle.config.site_logo)
        end
      elsif Trestle.config.site_logo_small
        safe_join([
          image_tag(Trestle.config.site_logo_small, alt: ""),
          content_tag(:span, Trestle.config.site_title, class: "visible-xs-inline visible-lg-inline")
        ], "\n")
      else
        safe_join([
          content_tag(:span, Trestle.config.site_title, class: "visible-xs-inline visible-lg-inline"),
          content_tag(:span, Trestle.config.site_title.split(/ /).map(&:first).first(3).join, class: "visible-sm-inline visible-md-inline")
        ], "\n")
      end
    end
  end
end
