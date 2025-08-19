require 'rails_helper'

RSpec.describe OrderLineItem, type: :model do
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
        order_line_item = OrderLineItem.new(product: product, order: order, quantity: 1, price: nil)
        expect(order_line_item).not_to be_valid
        expect(order_line_item.errors[:price]).to include("can't be blank")
      end
    end
  end
end
