require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:order_line_items).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
  end

  describe 'enums' do
    it 'defines status as a string enum' do
      expect(Order.defined_enums["status"]).to eq({
        "pending" => "pending",
        "processing" => "processing",
        "completed" => "completed",
        "cancelled" => "cancelled"
      })
    end
  end

  describe '#add_items_from_cart' do
    let(:user) { create(:user) }
    let(:cart) { create(:cart, user: user) }
    let(:order) { create(:order, user: user) }
    let(:product1) { create(:product, price: 19.99, special_offer: false) }
    let(:product2) { create(:product, price: 29.99, special_offer: false) }

    before do
      cart.add_product(product1, 2)
      cart.add_product(product2, 1)
      cart.save
    end

    it 'creates order line items from cart items' do
      expect {
        order.add_items_from_cart(cart)
        order.save
      }.to change(OrderLineItem, :count).by(2)
    end

    it 'copies the correct attributes from cart items' do
      order.add_items_from_cart(cart)
      order.save
      
      order_line_item1 = order.order_line_items.find_by(product_id: product1.id)
      order_line_item2 = order.order_line_items.find_by(product_id: product2.id)
      
      expect(order_line_item1.quantity).to eq(2)
      expect(order_line_item1.price_cents).to eq(19)
      expect(order_line_item2.quantity).to eq(1)
      expect(order_line_item2.price_cents).to eq(29)
    end

    it 'calculates the total price' do
      order.add_items_from_cart(cart)
      order.save
      
      expected_total = 0
      cart.cart_items.each do |item|
        expected_total += item.total_price_cents
      end
      
      expect(order.total_cents).to eq(expected_total)
    end
  end

  describe '#total_price_in_currency' do
    let(:user) { create(:user) }
    let(:order) { create(:order, user: user, total_cents: 5995) }

    it 'returns the total price in dollars' do
      expect(order.total_price_in_currency).to eq(59.95)
    end
  end

  describe '#calculate_total' do
    let(:user) { create(:user) }
    let(:order) { create(:order, user: user) }
    let(:product1) { create(:product, price: 19.99) }
    let(:product2) { create(:product, price: 29.99) }

    before do
      order.order_line_items.create(product: product1, quantity: 2, price: 19.99)
      order.order_line_items.create(product: product2, quantity: 1, price: 29.99)
    end

    it 'updates the total_cents attribute' do
      expected_total = 0
      order.order_line_items.each do |item|
        expected_total += item.total_price_cents
      end
      
      order.calculate_total
      expect(order.total_cents).to eq(expected_total)
    end
  end

  describe '.from_cart' do
    let(:user) { create(:user) }
    let(:cart) { create(:cart, user: user) }
    let(:product1) { create(:product, price: 19.99, special_offer: false) }
    let(:product2) { create(:product, price: 29.99, special_offer: false) }

    before do
      cart.add_product(product1, 2)
      cart.add_product(product2, 1)
      cart.save
    end

    it 'creates a new order for the user' do
      expect {
        Order.from_cart(cart, user)
      }.to change(user.orders, :count).by(1)
    end

    it 'adds all items from the cart to the order' do
      order = Order.from_cart(cart, user)
      expect(order.order_line_items.count).to eq(2)
    end

    it 'calculates the correct total' do
      order = Order.from_cart(cart, user)
      
      expected_total = 0
      cart.cart_items.each do |item|
        expected_total += item.total_price_cents
      end
      
      expect(order.total_cents).to eq(expected_total)
    end

    it 'returns a persisted order' do
      order = Order.from_cart(cart, user)
      expect(order).to be_persisted
    end
  end
end
