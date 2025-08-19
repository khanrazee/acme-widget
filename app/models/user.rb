class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include UserConcerns
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  after_create :create_default_cart

  ROLES = %w[admin customer].freeze
  validates :role, inclusion: { in: ROLES }

  private

  def create_default_cart
    if role == 'customer'
      create_cart unless cart
    end
  end
end
