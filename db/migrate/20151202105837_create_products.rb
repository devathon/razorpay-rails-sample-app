class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :price
      t.string :title
      t.string :description
      t.integer :seller_id

      t.timestamps null: false
    end
  end
end
