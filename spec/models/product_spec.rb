require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { should have_many(:cart_items).dependent(:destroy) }
    it { should have_many(:order_line_items).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:product, code: 'TEST123', name: 'Test Product', price: 19.99) }
    
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should validate_inclusion_of(:special_offer).in_array([true, false]) }
  end

  describe '#price_in_currency' do
    it 'returns the price divided by 100' do
      product = build(:product, price: 1999)
      expect(product.price_in_currency).to eq(19.99)
    end

    it 'returns nil when price is nil' do
      product = build(:product, price: nil)
      expect(product.price_in_currency).to be_nil
    end
  end

  describe '#price_in_currency=' do
    it 'does not change price when value is blank' do
      product = build(:product, price: 1999)
      original_price = product.price
      product.price_in_currency = ''
      expect(product.price).to eq(original_price)
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the allowed attributes for searching' do
      expected_attributes = %w[code created_at id name price updated_at]
      expect(Product.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'returns an empty array' do
      expect(Product.ransackable_associations).to eq([])
    end
  end
end
