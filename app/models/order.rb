class Order < ApplicationRecord
  include OrderConcerns

  belongs_to :user
  has_many :order_line_items, dependent: :destroy

  validates :status, presence: true
  validate :must_have_order_line_items, on: [:create]

  enum :status, {
    pending: 'pending',
    processing: 'processing',
    completed: 'completed',
    cancelled: 'cancelled'
  }, prefix: true

  private

  def must_have_order_line_items
    if order_line_items.empty?
      errors.add(:base, "Order cannot be processed without any items")
    end
  end
end
