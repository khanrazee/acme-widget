class Cart < ApplicationRecord
  include CartConcerns

  belongs_to :user
  has_many :cart_items, dependent: :destroy
end
