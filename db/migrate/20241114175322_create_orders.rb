class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.date :order_date
      t.references :status, null: false, foreign_key: true

      t.timestamps
    end
  end
end
