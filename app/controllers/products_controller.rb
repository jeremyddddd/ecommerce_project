class ProductsController < ApplicationController
  def index
    @categories = Category.all
    if params[:category_id].present?
      @products = Product.where(category_id: params[:category_id]).includes(:image_attachment, :category)
    else
      @products = Product.includes(:image_attachment, :category)
    end
  end
end
