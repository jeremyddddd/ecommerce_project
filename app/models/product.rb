class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details
  has_many :orders, through: :order_details
  has_one_attached :image

  attr_accessor :remove_image

  def self.ransackable_attributes(auth_object = nil)
    [ "category_id", "created_at", "description", "id", "price", "product_name", "stock_quantity", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "category", "image_attachment", "image_blob", "order_details", "orders" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    super + %w[on_sale sale_price created_at updated_at product_name description category_id]
  end
end
