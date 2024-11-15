class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "order_id", "order_price", "product_id", "quantity", "updated_at" ]
  end
end
