class UpdateProduct
  include Interactor

  def call
    product = context.product
    
    if context.params[:price_in_currency].present?
      product.price = context.params[:price_in_currency].to_f * 100
    end

    if product.update(context.params)
      context.product = product
    else
      context.fail!(message: "Failed to update product", product: product)
    end
  end
end
