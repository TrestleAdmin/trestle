module Trestle
  module StatusHelper
    # Renders a status indicator as a Bootstrap badge.
    # (https://getbootstrap.com/docs/5.3/components/badge/)
    #
    # label      - Status badge text or HTML content
    # status     - Status class (as .badge-{status}) to apply to the badge (default: :primary)
    # attributes - Additional HTML attributes to add to the <span> tag
    #
    # Examples
    #
    #   <%= status_tag("Status Text") %>
    #
    #   <%= status_tag(icon("fas fa-check"), :success) %>
    #
    #   <%= status_tag(safe_join([icon("fas fa-warning"), "Error"], " "), :danger,
    #                  data: { controller: "tooltip" }, title: "Full error message") %>
    #
    # Returns a HTML-safe String.
    def status_tag(label, status=:primary, **attributes)
      tag.span(label, **attributes.merge(class: ["badge", "badge-#{status}", attributes[:class]]))
    end
  end
end
