Trestle.admin(:media, scope: Components) do
  menu do
    group :components do
      item :media, icon: "fas fa-images", priority: 5
    end
  end

  # helper ImageHelper
end
