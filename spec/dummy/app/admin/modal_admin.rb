Trestle.resource(:modal, model: Post) do
  menu do
    item :modal, icon: "fa fa-star"
  end

  table do
    column :title, link: true
    actions
  end

  form modal: true do |post|
    modal_options!(class: "modal-lg")

    text_field :title
    text_area :body
  end
end
