class ProductsController < ApplicationController
  def index
    @products = Product.includes(:image_attachment, :image_blob, :category)
  end
end
