Trestle.resource(:dialog, model: Post) do
  menu do
    item :dialog, icon: "fa fa-star"
  end

  table do
    column :title, link: true
    actions
  end

  form dialog: true do |post|
    text_field :title
    text_area :body
  end
end
