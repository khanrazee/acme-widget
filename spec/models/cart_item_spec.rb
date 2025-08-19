require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'associations' do
    it { should belong_to(:product) }
    it { should belong_to(:cart) }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_greater_than(0).is_less_than_or_equal_to(15) }
    it { should validate_presence_of(:price_cents) }
    it { should validate_numericality_of(:price_cents).is_greater_than(0) }
    
    describe 'price validations' do
      let(:product) { create(:product) }
      let(:cart) { create(:cart) }
      
      it 'validates presence of price' do
        cart_item = CartItem.new(product: product, cart: cart, quantity: 1, price: nil)
        expect(cart_item).not_to be_valid
        expect(cart_item.errors[:price]).to include("can't be blank")
      end
      
      it 'validates that price is greater than 0' do
        cart_item = CartItem.new(product: product, cart: cart, quantity: 1, price: 0)
        expect(cart_item).not_to be_valid
        expect(cart_item.errors[:price]).to include("must be greater than 0")
      end
    end
  end

  describe '#total_price' do
    let(:product) { create(:product, price: 32.95) }
    let(:cart) { create(:cart) }
    
    context 'when product has no special offer' do
      before { product.update(special_offer: false) }
      
      it 'calculates the regular price for a single item' do
        cart_item = create(:cart_item, product: product, cart: cart, quantity: 1, price: 32.95)
        expect(cart_item.total_price).to eq(32.95)
      end
      
      it 'calculates the regular price for multiple items' do
        cart_item = create(:cart_item, product: product, cart: cart, quantity: 3, price: 32.95)
        expect(cart_item.total_price).to eq(98.85)
      end
    end
    
    context 'when product has special offer' do
      before { product.update(special_offer: true) }
      
      it 'calculates the regular price for a single item' do
        cart_item = create(:cart_item, product: product, cart: cart, quantity: 1, price: 32.95)
        expect(cart_item.total_price).to eq(32.95)
      end
      
      it 'applies discount for 2 items' do
        cart_item = create(:cart_item, product: product, cart: cart, quantity: 2, price: 32.95)
        expect(cart_item.total_price).to eq(49.42)
      end
      
      it 'applies discount for 3 items' do
        cart_item = create(:cart_item, product: product, cart: cart, quantity: 3, price: 32.95)
        expect(cart_item.total_price).to eq(82.37)
      end
      
      it 'applies discount for 4 items' do
        cart_item = create(:cart_item, product: product, cart: cart, quantity: 4, price: 32.95)
        expect(cart_item.total_price).to eq(98.85)
      end
    end
  end
  
  describe '#discount_applied?' do
    let(:product) { create(:product) }
    let(:cart) { create(:cart) }
    let(:cart_item) { create(:cart_item, product: product, cart: cart, quantity: 2) }
    
    it 'returns true when product has special offer and quantity >= 2' do
      product.update(special_offer: true)
      expect(cart_item.discount_applied?).to be true
    end
    
    it 'returns false when product has special offer but quantity < 2' do
      product.update(special_offer: true)
      cart_item.update(quantity: 1)
      expect(cart_item.discount_applied?).to be false
    end
    
    it 'returns false when product has no special offer' do
      product.update(special_offer: false)
      expect(cart_item.discount_applied?).to be false
    end
  end
  
  describe '#savings_amount' do
    let(:product) { create(:product, price: 32.95) }
    let(:cart) { create(:cart) }
    
    it 'returns correct savings for discounted items' do
      product.update(special_offer: true)
      cart_item = create(:cart_item, product: product, cart: cart, quantity: 2, price: 32.95)
      expect(cart_item.savings_amount).to eq(1648)
    end
    
    it 'returns 0 when no discount is applied' do
      product.update(special_offer: false)
      cart_item = create(:cart_item, product: product, cart: cart, quantity: 2, price: 32.95)
      expect(cart_item.savings_amount).to eq(0)
    end
  end
end
