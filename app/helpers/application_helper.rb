module ApplicationHelper

  def is_admin?
    current_user&.admin?
  end

  def is_customer?
    current_user&.customer?
  end
end
