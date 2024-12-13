class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_cart, only: [ :new, :create ]
  skip_before_action :authenticate_user!, only: [ :create_payment ]

  def new
    load_cart_items
    calculate_totals
  end

  def create
    # Ensures the cart exists
    cart = session[:cart]
    if cart.blank?
      redirect_to cart_path, alert: "Your cart is empty."
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

    # Calculate totals
    province = @order.user.province
    @subtotal = @order_items.sum { |item| item[:quantity] * item[:price] }
    @gst = @subtotal * province.gst / 100
    @pst = @subtotal * province.pst / 100
    @hst = @subtotal * province.hst / 100
    @total_taxes = @gst + @pst + @hst
    @total = @subtotal + @total_taxes
  end

  def create_payment
    @cart_items = session[:cart].map do |product_id, quantity|
      product = Product.find(product_id)
      {
        name: product.product_name,
        amount: (product.price * 100).to_i,
        quantity: quantity,
        product_id: product.id,
        price: product.price
      }
    end

    # Calculate taxes
    subtotal = @cart_items.sum { |item| item[:amount] * item[:quantity] } / 100.0
    province = current_user.province

    gst = (subtotal * province.gst / 100).round(2)
    pst = (subtotal * province.pst / 100).round(2)
    hst = (subtotal * province.hst / 100).round(2)
    total_taxes = (gst + pst + hst).round(2)

    # Add taxes as separate line items
    tax_items = [
      { name: "Total Taxes", amount: (total_taxes * 100).to_i, quantity: 1 }
    ]

    # Combine cart items and tax items
    stripe_line_items = @cart_items.map do |item|
      {
        price_data: {
          currency: "cad",
          product_data: { name: item[:name] },
          unit_amount: item[:amount]
        },
        quantity: item[:quantity]
      }
    end + tax_items.map do |tax_item|
      {
        price_data: {
          currency: "cad",
          product_data: { name: tax_item[:name] },
          unit_amount: tax_item[:amount]
        },
        quantity: 1
      }
    end

    # Store only essential data in metadata (e.g., product IDs and quantities)
    metadata = @cart_items.map { |item| { product_id: item[:product_id], quantity: item[:quantity] } }

    # Create a Stripe session
    stripe_session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      line_items: stripe_line_items,
      mode: "payment",
      success_url: "#{root_url}checkout/success?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: "#{root_url}checkout/cancel",
      metadata: { cart_items: metadata.to_json }
    )

    render json: { id: stripe_session.id }, status: :ok
  rescue => e
    Rails.logger.error "Stripe Error: #{e.message}"
    render json: { error: "Payment could not be created. Please try again." }, status: :internal_server_error
  end

  def success
    session_id = params[:session_id]

    # Retrieve Stripe session
    stripe_session = Stripe::Checkout::Session.retrieve(session_id)

    # Retrieve reduced metadata and recreate cart items
    cart_items_metadata = stripe_session.metadata["cart_items"]
    if cart_items_metadata.nil?
      Rails.logger.error "Stripe metadata is missing 'cart_items': #{stripe_session.metadata.inspect}"
      redirect_to cart_path, alert: "Payment data is incomplete. Please contact support."
      return
    end

    cart_items = JSON.parse(cart_items_metadata)

    # Create Order and Order Details
    order = Order.create!(
      user_id: current_user.id,
      order_date: Date.today,
      status_id: 1, # Pending
      payment_status: "Paid",
      stripe_payment_id: stripe_session.id
    )

    cart_items.each do |item|
      product = Product.find(item["product_id"])
      order.order_details.create!(
        product_id: product.id,
        quantity: item["quantity"],
        order_price: product.price
      )
    end

    # Clear cart and redirect to the invoice (show action)
    session[:cart] = nil
    redirect_to checkout_path(order), notice: "Payment successful! Your order has been placed."
  end

  def cancel
    # Optionally clear the cart or log a message
    flash[:alert] = "Payment process was canceled."
    redirect_to cart_path
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
end
