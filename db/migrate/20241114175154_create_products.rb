class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :product_name
      t.text :description
      t.text :price
      t.integer :stock_quantity
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
