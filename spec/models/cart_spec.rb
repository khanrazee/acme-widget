require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:cart_items).dependent(:destroy) }
  end

  describe '#add_product' do
    let(:user) { create(:user) }
    let(:cart) { create(:cart, user: user) }
    let(:product) { create(:product, price: 19.99, special_offer: false) }

    context 'when product is not in the cart' do
      it 'creates a new cart item' do
        expect {
          cart.add_product(product)
          cart.save
        }.to change(CartItem, :count).by(1)
      end

      it 'sets the correct attributes on the new cart item' do
        cart_item = cart.add_product(product, 2)
        cart.save
        cart_item.reload
        
        expect(cart_item.product).to eq(product)
        expect(cart_item.quantity).to eq(2)
        expect(cart_item.price_cents).to eq(19)
      end
    end

    context 'when product is already in the cart' do
      let!(:cart_item) { cart.add_product(product, 1) }
      
      before do
        cart.save
        cart_item.reload
      end

      it 'does not create a new cart item' do
        expect {
          cart.add_product(product, 2)
          cart.save
        }.not_to change(CartItem, :count)
      end

      it 'increases the quantity of the existing cart item' do
        updated_item = cart.add_product(product, 2)
        updated_item.save
        updated_item.reload
        
        expect(updated_item.quantity).to eq(3)
      end
    end
  end

  describe '#remove_product' do
    let(:user) { create(:user) }
    let(:cart) { create(:cart, user: user) }
    let(:product) { create(:product, price: 19.99, special_offer: false) }

    before do
      cart.add_product(product, 2)
      cart.save
    end

    it 'removes the product from the cart' do
      expect {
        cart.remove_product(product)
      }.to change(CartItem, :count).by(-1)
    end
  end

  describe '#total_price_cents' do
    let(:user) { create(:user) }
    let(:cart) { create(:cart, user: user) }
    let(:product1) { create(:product, price: 10.00) }
    let(:product2) { create(:product, price: 15.50) }

    context 'with no special offers' do
      before do
        product1.update(special_offer: false)
        product2.update(special_offer: false)
        cart.add_product(product1, 2)
        cart.add_product(product2, 1)
        cart.save
      end

      it 'returns the sum of all cart items total prices' do
        expect(cart.total_price_cents).to eq(35)
      end
    end

    context 'with special offers' do
      before do
        product1.update(special_offer: true)
        product2.update(special_offer: false)
        cart.add_product(product1, 2)
        cart.add_product(product2, 1)
        cart.save
      end

      it 'returns the sum of all cart items total prices with discounts applied' do
        expect(cart.total_price_cents).to eq(30)
      end
    end
  end

  describe '#total_price_in_currency' do
    let(:user) { create(:user) }
    let(:cart) { create(:cart, user: user) }
    let(:product) { create(:product, price: 24.99) }

    context 'with no special offer' do
      before do
        product.update(special_offer: false)
        cart.add_product(product, 2)
        cart.save
      end

      it 'returns the total price in dollars' do
        expect(cart.total_price_in_currency).to eq(0.48)
      end
    end

    context 'with special offer' do
      before do
        product.update(special_offer: true)
        cart.add_product(product, 2)
        cart.save
      end

      it 'returns the total price in dollars with discount' do
        expect(cart.total_price_in_currency).to eq(0.36)
      end
    end
  end

  describe '#subtotal' do
    let(:user) { create(:user) }
    let(:cart) { create(:cart, user: user) }
    let(:product) { create(:product, price: 19.99) }

    before do
      cart.add_product(product, 2)
      cart.save
    end

    it 'returns the same value as total_price_cents' do
      expect(cart.subtotal).to eq(cart.total_price_cents)
    end
  end

  describe '#total_savings_amount' do
    let(:user) { create(:user) }
    let(:cart) { create(:cart, user: user) }
    let(:product1) { create(:product, price: 20.00, special_offer: true) }
    let(:product2) { create(:product, price: 10.00, special_offer: false) }

    before do
      cart.add_product(product1, 2)
      cart.add_product(product2, 1)
      cart.save
    end

    it 'returns the sum of all savings from cart items' do
      expect(cart.total_savings_amount).to eq(10)
    end
  end

  describe '#total_savings_in_currency' do
    let(:user) { create(:user) }
    let(:cart) { create(:cart, user: user) }
    let(:product) { create(:product, price: 20.00, special_offer: true) }

    before do
      cart.add_product(product, 2)
      cart.save
    end

    it 'returns the total savings in dollars' do
      expect(cart.total_savings_in_currency).to eq(0.10)
    end
  end
end
