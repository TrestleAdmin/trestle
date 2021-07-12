Trestle.resource(:offices) do
  menu do
    item :offices, icon: "fas fa-building"
  end

  table do
    column :city, link: true
    column :country
    column :phone
    column :url do |office|
      link_to office.url, office.url, target: "_blank"
    end
    actions
  end

  form dialog: true do
    row do
      col { text_field :city }
      col { text_field :country }
    end

    text_field :address_1, label: "Address"
    text_field :address_2, label: false

    divider

    url_field :url, prepend: icon("fas fa-link")
    phone_field :phone, prepend: icon("fas fa-phone-alt")
  end
end
