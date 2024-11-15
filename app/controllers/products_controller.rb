class ProductsController < ApplicationController
  def index
    @q = Product.ransack(params[:q])
    @categories = Category.all

    if params[:category_id].present?
      @products = @q.result.includes(:category).where(category_id: params[:category_id])
    else
      @products = @q.result.includes(:category)
    end
  end
end
