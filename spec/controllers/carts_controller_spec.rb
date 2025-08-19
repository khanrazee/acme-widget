require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  login_user

  let(:product) { create(:product) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update for add_to_cart' do
    context 'with valid parameters' do
      it 'adds a product to the cart' do
        expect do
          patch :update, params: { id: controller.current_user.cart.id, product_id: product.id, quantity: 2 }
        end.to change { controller.current_user.cart.cart_items.count }.by(1)
      end

      it 'redirects to cart_path with a notice' do
        patch :update, params: { id: controller.current_user.cart.id, product_id: product.id, quantity: 2 }
        expect(response).to redirect_to(cart_path)
        expect(flash[:notice]).to include('successfully added to your cart')
      end
    end

    context 'with invalid parameters' do
      it 'redirects back with an alert when quantity is less than 1' do
        patch :update, params: { id: controller.current_user.cart.id, product_id: product.id, quantity: 0 }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Product not found in cart')
      end
    end
  end

  describe 'PATCH #update for update_quantity' do
    context 'when increasing quantity' do
      before do
        user = controller.current_user
        cart = user.cart
        cart.add_product(product, 1)
        cart.save
      end

      it 'updates the quantity of the cart item' do
        expect do
          patch :update, params: { id: controller.current_user.cart.id, product_id: product.id, quantity: 3 }
        end.to change {
          controller.current_user.cart.cart_items.find_by(product_id: product.id)&.quantity
        }.from(1).to(3)
      end

      it 'redirects to cart_path with a notice' do
        patch :update, params: { id: controller.current_user.cart.id, product_id: product.id, quantity: 3 }
        expect(response).to redirect_to(cart_path)
        expect(flash[:notice]).to eq('Cart updated successfully.')
      end
    end

    context 'when removing product' do
      before do
        user = controller.current_user
        cart = user.cart
        cart.add_product(product, 1)
        cart.save
      end

      it 'removes the product from the cart' do
        expect do
          patch :update, params: { id: controller.current_user.cart.id, product_id: product.id, quantity: 0 }
        end.to change { controller.current_user.cart.cart_items.count }.by(-1)
      end

      it 'redirects to cart_path with a notice' do
        patch :update, params: { id: controller.current_user.cart.id, product_id: product.id, quantity: 0 }
        expect(response).to redirect_to(cart_path)
        expect(flash[:notice]).to eq('Cart updated successfully.')
      end
    end
  end

  describe 'GET #checkout' do
    context 'with items in cart' do
      before do
        user = controller.current_user
        cart = user.cart
        cart.add_product(product, 1).save
      end

      it 'returns a success response' do
        get :checkout, params: { id: controller.current_user.cart.id }
        expect(response).to be_successful
      end

      it 'assigns a new order as @order' do
        get :checkout, params: { id: controller.current_user.cart.id }
        expect(assigns(:order)).to be_a_new(Order)
      end
    end

    context 'with empty cart' do
      it 'redirects to cart_path with an alert' do
        get :checkout, params: { id: controller.current_user.cart.id }
        expect(response).to redirect_to(cart_path)
        expect(flash[:alert]).to eq('Your cart is empty.')
      end
    end
  end
end
