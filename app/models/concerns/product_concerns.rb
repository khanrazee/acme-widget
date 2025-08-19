module ProductConcerns
  extend ActiveSupport::Concern

  def price_in_currency=(value)
    self.price = value.to_f * 100 if value.present?
  end
  
  module ClassMethods
    def ransackable_attributes(_auth_object = nil)
      %w[code created_at id name price updated_at]
    end

    def ransackable_associations(_auth_object = nil)
      []
    end
  end
end
