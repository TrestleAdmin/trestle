Trestle.resource(:articles) do
  menu do
    item :articles, icon: "fas fa-newspaper"
  end

  collection do
    model.order(created_at: :desc).includes(:author, :categories)
  end

  scopes do
    scope :all, default: true
    scope :active
  end

  hook "index.toolbar.secondary" do |t|
    t.link "Batch Action (GET)", action: :batch_get, style: :info, data: { controller: "batch-action" }
    t.link "Batch Action (POST)", action: :batch_post, style: :warning, data: { controller: "confirm batch-action", turbo_method: :post }
  end

  hook "new.toolbar.secondary" do |t|
    t.link "Cancel", action: :index
  end

  table do
    selectable_column
    column :title, link: true, truncate: false
    column :author, sort: :author do |article|
      admin_link_to article.author, class: "user-link" do
        safe_join([
          avatar(fallback: article.author.initials, style: "background: #{article.author.avatar_color}", class: "avatar-sm mr-1") { gravatar(article.author.email, d: article.author.avatar_type_value) },
          article.author.full_name
        ], " ")
      end
    end
    column :categories, format: :tags, sort: false
    column :active, align: :center
    column :published_at, align: :center
    actions
  end

  sort_column :author do |collection, order|
    collection.joins(:author).merge(User.alphabetical(order))
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

  controller do
    def batch_get
      ids = params[:ids].split(",")
      flash[:message] = { title: "Success!", message: "Performed batch action via GET with #{ids.size} articles." }
      redirect_back fallback_location: admin.path
    end

    def batch_post
      ids = params[:ids].split(",")
      flash[:message] = { title: "Success!", message: "Performed batch action via POST with #{ids.size} articles." }
      redirect_back fallback_location: admin.path
    end
  end

  routes do
    collection do
      get :batch_get
      post :batch_post
    end
  end
end
