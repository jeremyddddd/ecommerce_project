class ChangePriceToDecimalInProducts < ActiveRecord::Migration[7.0]
  def change
    change_column :products, :price, :decimal, precision: 8, scale: 2, using: 'price::numeric'
  end
end
