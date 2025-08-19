class CartPolicy < ApplicationPolicy

  def index?
    user.customer?
  end

  def update?
    user.customer?
  end

  def checkout?
    user.customer?
  end

  def destroy?
    user.customer?
  end
end
