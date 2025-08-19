require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_one(:cart).dependent(:destroy) }
    it { should have_many(:orders).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:role).in_array(%w[admin customer]) }
  end

  describe 'callbacks' do
    context 'after_create' do
      it 'creates a default cart for customer users' do
        user = build(:user, role: 'customer')
        expect { user.save }.to change(Cart, :count).by(1)
        expect(user.cart).to be_present
      end

      it 'does not create a cart for admin users' do
        user = build(:user, role: 'admin')
        expect { user.save }.to change(Cart, :count).by(0)
        expect(user.cart).to be_nil
      end
    end
  end

  describe '#current_cart' do
    let(:user) { create(:user, role: 'customer') }

    context 'when user has a cart' do
      it 'returns the existing cart' do
        expect(user.current_cart).to eq(user.cart)
      end
    end

    context 'when user does not have a cart' do
      before { user.cart.destroy }

      it 'creates and returns a new cart' do
        user.reload
        cart = nil
        expect { cart = user.current_cart }.to change { user.reload.cart.present? }.from(false).to(true)
        expect(cart).to be_a(Cart)
      end
    end
  end

  describe '#checkout_cart' do
    let(:user) { create(:user, role: 'customer') }
    let(:product) { create(:product, price: 19.99) }

    context 'when cart has items' do
      before do
        user.cart.add_product(product, 2)
        user.cart.save
      end

      it 'creates an order from the cart' do
        expect { user.checkout_cart }.to change(Order, :count).by(1)
        expect(user.orders.last.order_line_items.count).to eq(1)
      end
    end

    context 'when cart is empty' do
      it 'returns nil' do
        expect(user.checkout_cart).to be_nil
      end
    end

    context 'when cart does not exist' do
      before { user.cart.destroy }

      it 'returns nil' do
        user.reload
        expect(user.checkout_cart).to be_nil
      end
    end
  end

  describe '#admin?' do
    it 'returns true when role is admin' do
      user = build(:user, role: 'admin')
      expect(user.admin?).to be true
    end

    it 'returns false when role is not admin' do
      user = build(:user, role: 'customer')
      expect(user.admin?).to be false
    end
  end

  describe '#customer?' do
    it 'returns true when role is customer' do
      user = build(:user, role: 'customer')
      expect(user.customer?).to be true
    end

    it 'returns false when role is not customer' do
      user = build(:user, role: 'admin')
      expect(user.customer?).to be false
    end
  end
end
