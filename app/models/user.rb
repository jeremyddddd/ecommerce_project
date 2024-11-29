class User < ApplicationRecord
  has_many :orders
  belongs_to :province, optional: true

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  def self.ransackable_associations(auth_object = nil)
    [ "orders" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "address", "created_at", "email", "first_name", "id", "last_name", "password", "phone_number", "updated_at" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    super + %w[province_id email address]
  end
end
