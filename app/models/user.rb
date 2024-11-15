class User < ApplicationRecord
  has_many :orders

  def self.ransackable_associations(auth_object = nil)
    [ "orders" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "address", "created_at", "email", "first_name", "id", "last_name", "password", "phone_number", "updated_at" ]
  end
end
