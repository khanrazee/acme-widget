require 'rails_helper'

RSpec.describe LineItem, type: :model do
  describe 'associations' do
    it { should belong_to(:product) }
    it { should belong_to(:order) }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
    
    describe 'price validations' do
      let(:product) { create(:product) }
      let(:order) { create(:order) }
      
      it 'validates presence of price' do
        line_item = LineItem.new(product: product, order: order, quantity: 1, price: nil)
        expect(line_item).not_to be_valid
        expect(line_item.errors[:price]).to include("can't be blank")
      end
      
      it 'validates that price is greater than 0' do
        line_item = LineItem.new(product: product, order: order, quantity: 1, price: 0)
        expect(line_item).not_to be_valid
        expect(line_item.errors[:price]).to include("must be greater than 0")
      end
    end
  end

  describe '#total_price' do
    let(:product) { create(:product, price: 32.95) }
    let(:order) { create(:order) }
    
    context 'when product has no special offer' do
      before { product.update(special_offer: false) }
      
      it 'calculates the regular price for a single item' do
        line_item = create(:line_item, product: product, order: order, quantity: 1, price: 32.95)
        expect(line_item.total_price).to eq(32.95)
      end
      
      it 'calculates the regular price for multiple items' do
        line_item = create(:line_item, product: product, order: order, quantity: 3, price: 32.95)
        expect(line_item.total_price).to eq(98.85) # 3 * 32.95
      end
    end
    
    context 'when product has special offer' do
      before { product.update(special_offer: true) }
      
      it 'calculates the regular price for a single item' do
        line_item = create(:line_item, product: product, order: order, quantity: 1, price: 32.95)
        expect(line_item.total_price).to eq(32.95)
      end
      
      it 'applies discount for 2 items' do
        line_item = create(:line_item, product: product, order: order, quantity: 2, price: 32.95)
        expect(line_item.total_price).to eq(49.42) # 32.95 + (32.95 * 50 / 100)
      end
      
      it 'applies discount for 3 items' do
        line_item = create(:line_item, product: product, order: order, quantity: 3, price: 32.95)
        expect(line_item.total_price).to eq(82.37) # (32.95 * 2) + (32.95 * 50 / 100)
      end
      
      it 'applies discount for 4 items' do
        line_item = create(:line_item, product: product, order: order, quantity: 4, price: 32.95)
        expect(line_item.total_price).to eq(98.85) # (32.95 * 2) + (32.95 * 2 * 50 / 100)
      end
    end
  end
  
  describe '#discount_applied?' do
    let(:product) { create(:product) }
    let(:order) { create(:order) }
    let(:line_item) { create(:line_item, product: product, order: order, quantity: 2) }
    
    it 'returns true when product has special offer and quantity >= 2' do
      product.update(special_offer: true)
      expect(line_item.discount_applied?).to be true
    end
    
    it 'returns false when product has special offer but quantity < 2' do
      product.update(special_offer: true)
      line_item.update(quantity: 1)
      expect(line_item.discount_applied?).to be false
    end
    
    it 'returns false when product has no special offer' do
      product.update(special_offer: false)
      expect(line_item.discount_applied?).to be false
    end
  end
  
  describe '#savings_amount' do
    let(:product) { create(:product, price: 32.95) }
    let(:order) { create(:order) }
    
    it 'returns correct savings for discounted items' do
      product.update(special_offer: true)
      line_item = create(:line_item, product: product, order: order, quantity: 2, price: 32.95)
      expect(line_item.savings_amount).to eq(1648)
    end
    
    it 'returns 0 when no discount is applied' do
      product.update(special_offer: false)
      line_item = create(:line_item, product: product, order: order, quantity: 2, price: 32.95)
      expect(line_item.savings_amount).to eq(0)
    end
  end
  
  describe '.from_cart_item' do
    let(:product) { create(:product, price: 32.95) }
    let(:cart) { create(:cart) }
    let(:cart_item) { create(:cart_item, product: product, cart: cart, quantity: 2, price: 32.95) }
    
    it 'creates a line item with the same attributes as the cart item' do
      line_item = LineItem.from_cart_item(cart_item)
      
      expect(line_item.product).to eq(product)
      expect(line_item.quantity).to eq(2)
      expect(line_item.price).to eq(32.95)
      expect(line_item.new_record?).to be true
    end
  end
end
