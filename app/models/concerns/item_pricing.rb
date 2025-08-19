module ItemPricing
  extend ActiveSupport::Concern

  def total_price_cents
    if product.special_offer && quantity >= 2
      full_price_count = (quantity / 2.0).ceil
      half_price_count = (quantity / 2.0).floor
      
      full_price_total = price_cents * full_price_count
      half_price_total = (price_cents * half_price_count * 50) / 100
      
      full_price_total + half_price_total
    else
      price_cents * quantity
    end
  end

  def total_price_in_currency
    total_price_cents / 100.0
  end

  def unit_price_in_currency
    price_cents / 100.0
  end
  
  def discount_applied?
    product.special_offer && quantity >= 2
  end
  
  def savings_amount
    if discount_applied?
      regular_total = price_cents * quantity
      discounted_total = total_price_cents
      regular_total - discounted_total
    else
      0
    end
  end
  
  def savings_in_currency
    savings_amount / 100.0
  end

  def price
    price_cents.to_f / 100 if price_cents
  end

  def price=(value)
    self.price_cents = (value.to_f * 100).round if value.present?
  end

  def total_price
    total_price_cents.to_f / 100 if total_price_cents
  end
end
