Trestle.resource(:scopes, model: Post) do
  menu do
    item :scopes, icon: "fa fa-star"
  end

  scopes do
    scope :all
    scope :published
    scope :block_scope do
      Post.where(title: "Published 1")
    end
    scope :proc_scope, -> { Post.where(title: "Published 1") }

    scope :context_variable, -> { Post.where(title: context_variable) }
    scope :context_boolean, -> { Post.none } if context_boolean?
  end

  scopes do
    scope :second_block, -> { Post.where(title: "Second Block") }
  end

  controller do
    def context_variable
      "Published 1"
    end

    def context_boolean?
      true
    end
  end

  table do
    column :title, link: true
    actions
  end

  form do |post|
    text_field :title
    text_area :body
  end
end
