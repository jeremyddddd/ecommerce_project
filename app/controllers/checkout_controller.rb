class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_cart, only: [ :new, :create ]

  def new
    load_cart_items
    calculate_totals
    check_missing_user_details
  end

  def create
    # Ensures the cart exists
    cart = session[:cart]
    if cart.blank?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    # Checks for missing user details
    if current_user.address.blank? || current_user.province_id.nil?
      redirect_to new_checkout_path, alert: "Please provide your address and province."
      return
    end

    # Reconstructs cart items
    @cart_items = cart.map do |product_id, quantity|
      product = Product.find(product_id)
      {
        product: product,
        quantity: quantity.to_i,
        subtotal: product.price * quantity.to_i
      }
    end

    # Calculate total taxes and amount
    subtotal = @cart_items.sum { |item| item[:subtotal] }
    province = current_user.province

    gst = subtotal * province.gst / 100
    pst = subtotal * province.pst / 100
    hst = subtotal * province.hst / 100
    total_taxes = gst + pst + hst
    total = subtotal + total_taxes

    # Create Order
    order = Order.create!(
      user_id: current_user.id,
      order_date: Date.today,
      status_id: 1
    )

    # Create Order Details
    @cart_items.each do |item|
      order.order_details.create!(
        product_id: item[:product].id,
        quantity: item[:quantity],
        order_price: item[:product].price
      )
    end

    # Clear the cart
    session[:cart] = nil

    # Redirect to invoice page
    redirect_to checkout_path(order.id), notice: "Order placed successfully!"
  end

  def show
    @order = Order.includes(:order_details).find(params[:id])
    @order_items = @order.order_details.map do |detail|
      {
        product: Product.find(detail.product_id),
        quantity: detail.quantity,
        price: detail.order_price
      }
    end

    calculate_order_totals(@order_items, @order.user.province)
  end

  private

  def validate_cart
    if session[:cart].blank?
      redirect_to cart_path, alert: "Your cart is empty."
    end
  end

  def load_cart_items
    @cart_items = session[:cart].map do |product_id, quantity|
      product = Product.find(product_id)
      {
        product: product,
        quantity: quantity.to_i,
        subtotal: product.price * quantity.to_i
      }
    end
  end

  def calculate_totals
    @subtotal = @cart_items.sum { |item| item[:subtotal] }
    province = current_user.province

    @gst = @subtotal * province.gst / 100
    @pst = @subtotal * province.pst / 100
    @hst = @subtotal * province.hst / 100
    @total_taxes = @gst + @pst + @hst
    @total = @subtotal + @total_taxes
  end

  def calculate_order_totals(order_items, province)
    @subtotal = order_items.sum { |item| item[:quantity] * item[:price] }

    @gst = @subtotal * province.gst / 100
    @pst = @subtotal * province.pst / 100
    @hst = @subtotal * province.hst / 100
    @total_taxes = @gst + @pst + @hst
    @total = @subtotal + @total_taxes
  end

  def check_missing_user_details
    @address_missing = current_user.address.blank?
    @province_missing = current_user.province.blank?
  end
end
