Trestle.configure do |config|
  config.site_title = "Trestle Sandbox"

  config.site_logo = "logo.svg"
  config.site_logo_small = "logo-small.svg"

  config.menu do
    group "Badges & Labels", priority: :last do
      item "Item with counter", "#", badge: { text: 99, class: "badge-primary badge-pill" }, priority: :first
      item "Item with badge", "#", badge: { text: "NEW!", class: "badge-success" }, icon: "fa fa-car"
    end
  end

  # config.helper -> { ImageHelper }
  config.helper "ImageHelper"

  # config.form_field :custom_field, -> { CustomField }
  config.form_field :custom_field, "CustomField"
end
