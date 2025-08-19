class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :display_orders, only: :index
  before_action :set_order, only: [:show]
  before_action :set_cart, only: [:create]
  before_action :validate_cart_not_empty, only: [:create]

  def index; end

  def show; end

  def create
    result = CreateOrderFromCart.call(cart: @cart, user: current_user)

    if result.success?
      @order = result.order
      redirect_to @order, notice: 'Your order has been placed successfully!'
    else
      redirect_to checkout_cart_path(@cart), alert: result.message
    end
  end

  private

  def display_orders
    orders = if current_user.admin?
               Order.all.order(created_at: :desc)
             else
               current_user.orders.order(created_at: :desc)
             end

    @orders = orders.page(params[:page]).per(10)
  end

  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: 'Order not found.'
  end
  
  def set_cart
    @cart = current_user.cart
  end
  
  def validate_cart_not_empty
    if @cart.cart_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty.'
    end
  end
end
