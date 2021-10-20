class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest

      t.string :first_name
      t.string :last_name

      t.date :date_of_birth

      t.string :avatar_type
      t.string :time_zone

      t.references :office
      t.integer :level

      t.timestamps
    end
  end
end
