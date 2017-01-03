Trestle.configure do |config|
  config.site_title = "Trestle Sandbox"

  config.menu do
    group "Badges & Labels" do
      item "Item with counter", "#", badge: { text: (1..100).to_a.sample, class: "label-primary label-pill" }, priority: :first
      item "Item with badge", "#", badge: { text: "NEW!", class: "label-success" }, icon: "fa fa-car"
    end
  end
end
