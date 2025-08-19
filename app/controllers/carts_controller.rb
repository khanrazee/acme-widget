class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :set_product, only: [:update]
  before_action :validate_cart_not_empty, only: [:checkout]
  before_action :authorize_user

  def index; end

  def update
    result = UpdateCart.call(
      cart: @cart,
      product: @product,
      quantity: @quantity
    )

    if result.success?
      if result.is_new_item
        notice = "#{result.product.name} successfully added to your cart."
      else
        notice = 'Cart updated successfully.'
      end
      redirect_to cart_path, notice: notice
    else
      redirect_to request.referer || root_path, alert: result.message
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to cart_path, alert: 'Product not found.'
  end

  def checkout
    @order = Order.new
  end

  def destroy
    @cart.cart_items.destroy_all
    redirect_to cart_path, notice: 'Your cart has been cleared.'
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart
  end

  def set_product
    @product = Product.find(params[:product_id])
    @quantity = params[:quantity].to_i
  end
  
  def validate_cart_not_empty
    if @cart.cart_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty.'
    end
  end

  def authorize_user
    authorize current_user, policy_class: CartPolicy
  end
end
