class Order < ApplicationRecord
  belongs_to :user
  belongs_to :status
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details

  def self.ransackable_associations(auth_object = nil)
    [ "order_details", "products", "status", "user" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "order_date", "status_id", "updated_at", "user_id", "payment_status", "stripe_payment_id" ]
  end
end
