class CreateArticlesCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :articles_categories, id: false do |t|
      t.references :article
      t.references :category
    end
  end
end
