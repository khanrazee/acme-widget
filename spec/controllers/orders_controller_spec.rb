require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  login_user

  let(:product) { create(:product) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all user orders as @orders' do
      order = create(:order, user: controller.current_user)
      get :index
      expect(assigns(:orders)).to eq([order])
    end
  end

  describe 'GET #show' do
    context 'with a valid order' do
      let(:order) { create(:order, user: controller.current_user) }

      it 'returns a success response' do
        get :show, params: { id: order.id }
        expect(response).to be_successful
      end

      it 'assigns the requested order as @order' do
        get :show, params: { id: order.id }
        expect(assigns(:order)).to eq(order)
      end
    end

    context 'with an invalid order' do
      it 'redirects to orders_path with an alert' do
        get :show, params: { id: 999 }
        expect(response).to redirect_to(orders_path)
        expect(flash[:alert]).to eq('Order not found.')
      end
    end
  end

  describe 'POST #create' do
    context 'with items in cart' do
      before do
        user = controller.current_user
        cart = user.cart
        cart.add_product(product, 1).save
      end

      it 'creates a new order' do
        expect do
          post :create
        end.to change(Order, :count).by(1)
      end

      it 'assigns the newly created order as @order' do
        post :create
        expect(assigns(:order)).to be_a(Order)
        expect(assigns(:order)).to be_persisted
      end

      it 'clears the cart items' do
        post :create
        expect(controller.current_user.cart.cart_items.count).to eq(0)
      end

      it 'redirects to the created order with a notice' do
        post :create
        expect(response).to redirect_to(Order.last)
        expect(flash[:notice]).to eq('Your order has been placed successfully!')
      end

      it 'sets the order status to completed' do
        post :create
        expect(Order.last.status).to eq('completed')
      end
    end

    context 'with empty cart' do
      it 'redirects to cart_path with an alert' do
        post :create
        expect(response).to redirect_to(cart_path)
        expect(flash[:alert]).to eq('Your cart is empty.')
      end
    end

    context 'when order creation fails' do
      before do
        user = controller.current_user
        cart = user.cart
        cart.add_product(product, 1).save

        # Mock the CreateOrderFromCart interactor to fail
        result = double('result')
        allow(result).to receive_messages(success?: false,
                                          message: 'There was a problem creating your order.')
        allow(CreateOrderFromCart).to receive(:call).and_return(result)
      end

      it 'redirects to checkout with an alert' do
        post :create
        expect(response).to redirect_to(checkout_cart_path(controller.current_user.cart))
        expect(flash[:alert]).to eq('There was a problem creating your order.')
      end
    end
  end
end
