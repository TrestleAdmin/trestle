Trestle.resource(:singular_post, model: Post, singular: true) do
  menu do
    item :singular, icon: "fas fa-star"
  end

  remove_action :new, :create, :edit, :destroy

  instance do
    model.first
  end

  form do |post|
    text_field :title
    text_area :body
  end
end
