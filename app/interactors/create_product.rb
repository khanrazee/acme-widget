class CreateProduct
  include Interactor

  def call
    product = Product.new(context.params)
    
    if context.params[:price_in_currency].present?
      product.price = context.params[:price_in_currency].to_f * 100
    end

    if product.save
      context.product = product
    else
      context.fail!(message: "Failed to create product", product: product)
    end
  end
end
