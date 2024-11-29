class ProductsController < ApplicationController
  def index
    @q = Product.ransack(params[:q])
    @categories = Category.all

    @products = @q.result.includes(:category)

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:filter] == "on_sale"
      @products = @products.where(on_sale: true)
    end

    if params[:filter] == "new"
      @products = @products.where("created_at >= ?", 3.days.ago)
    end

    if params[:filter] == "recently_updated"
      @products = @products.where("updated_at >= ?", 3.days.ago).where("created_at < updated_at")
    end

    @products = @products.page(params[:page]).per(10)
  end

  def show
    @product = Product.find(params[:id])
  end
end
