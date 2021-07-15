Trestle.resource(:articles) do
  menu do
    item :articles, icon: "fas fa-newspaper"
  end

  collection do
    model.order(created_at: :desc).includes(:author, :categories)
  end

  table do
    column :title, link: true, truncate: false
    column :author do |article|
      admin_link_to article.author do
        safe_join([
          avatar(fallback: article.author.initials, style: "background: #{article.author.avatar_color}", class: "avatar-sm mr-1") { gravatar(article.author.email, d: article.author.avatar_type) },
          article.author.full_name
        ], " ")
      end
    end
    column :categories, format: :tags
    column :active, align: :center
    column :published_at, align: :center
    actions
  end

  form do |article|
    tab :article do
      text_field :title
      text_area :content, rows: 20, maxlength: 2500, help: { text: "Maximum length: 2500 characters", float: true }
    end

    sidebar do
      select :author_id, User.alphabetical, include_blank: "- Select Author -"

      divider

      datetime_field :published_at

      form_group do
        check_box :active
      end

      divider

      select :category_ids, Category.alphabetical, { label: "Categories" }, multiple: true

      tag_select :tags
    end
  end
end
