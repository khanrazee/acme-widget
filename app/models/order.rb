class Order < ApplicationRecord
  include OrderConcerns
  belongs_to :user
  has_many :line_items, dependent: :destroy

  validates :status, presence: true

  enum :status, {
    pending: 'pending',
    processing: 'processing',
    completed: 'completed',
    cancelled: 'cancelled'
  }, prefix: true
end
