Trestle.configure do |config|
  config.menu do
    item :dashboard, "/", icon: "fa fa-dashboard"

    group "Group 1" do
      item "Navigation Item 1", "#", icon: "fa fa-user"
      item "Navigation Item 2", "#", icon: "fa fa-car"
    end
  end
end
