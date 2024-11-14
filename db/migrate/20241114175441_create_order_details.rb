class CreateOrderDetails < ActiveRecord::Migration[7.2]
  def change
    create_table :order_details do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :order_price

      t.timestamps
    end
  end
end
