class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content

      t.datetime :published_at
      t.boolean :active, default: false
      t.text :tags

      t.references :author

      t.timestamps
    end
  end
end
