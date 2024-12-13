class AddPaymentFieldsToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :payment_status, :string
    add_column :orders, :stripe_payment_id, :string
  end
end
