Trestle.resource(:categories) do
  menu do
    item :categories, icon: "fa fa-tags"
  end

  collection do
    model.alphabetical
  end

  table do
    selectable_column
    column :name, link: true
    column :color do |category|
      status_tag category.color, :none, style: "background: #{category.color}"
    end
    actions
  end

  form dialog: true do
    text_field :name
    color_field :color
  end
end
