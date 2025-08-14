class CartPolicy < ApplicationPolicy

  def index?
    user.customer?
  end

  def add_to_cart?
    user.customer?
  end

  def update_quantity?
    user.customer?
  end

  def checkout?
    user.customer?
  end

  def destroy?
    user.customer?
  end
end
