class CartsController < ApplicationController
  def show
    @cart = session[:cart] || {}
    @products = Product.where(id: @cart.keys)
  end

  def add
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    session[:cart] ||= {}

    if session[:cart][product_id]
      session[:cart][product_id] += quantity
    else
      session[:cart][product_id] = quantity
    end

    redirect_to cart_path, notice: "Product added to cart!"
  end

  def update
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    if quantity > 0
      session[:cart][product_id] = quantity
    else
      session[:cart].delete(product_id)
    end

    redirect_to cart_path, notice: "Cart updated!"
  end

  def remove
    product_id = params[:product_id]
    session[:cart].delete(product_id)

    redirect_to cart_path, notice: "Product removed from cart!"
  end
end
