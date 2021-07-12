class CreateOffices < ActiveRecord::Migration[6.1]
  def change
    create_table :offices do |t|
      t.string :city
      t.string :country

      t.string :address_1
      t.string :address_2

      t.string :url
      t.string :phone

      t.timestamps
    end
  end
end
