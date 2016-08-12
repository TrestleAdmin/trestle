Trestle.configure do |config|
  config.site_title = "Trestle Sandbox"

  config.menu do
    item :dashboard, "/", icon: "fa fa-dashboard", badge: { text: "NEW!", class: "label-success" }

    group "Group 1" do
      item "Navigation Item 1", "#", icon: "fa fa-user", badge: { text: 9, class: "label-primary label-pill" }
      item "Navigation Item 2", "#", icon: "fa fa-car"
    end
  end
end
