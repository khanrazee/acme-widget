class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :authorize_user, except: [:index]

  def index
    @q = Product.ransack(params[:q])
    @products = policy_scope(@q.result).page(params[:page]).per(10)
  end

  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    result = CreateProduct.call(params: product_params)

    if result.success?
      redirect_to products_path, notice: 'Product successfully created.'
    else
      @product = result.product
      render :new, status: :unprocessable_entity
    end
  end

  def update
    result = UpdateProduct.call(product: @product, params: product_params)
    
    if result.success?
      redirect_to products_path, notice: 'Product successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      redirect_to products_path, notice: 'Product successfully deleted.'
    else
      redirect_to products_path,
                  alert: 'Cannot delete product because it has associated orders. Please archive it instead.'
    end
  rescue ActiveRecord::DeleteRestrictionError
    redirect_to products_path,
                alert: 'Cannot delete product because it has associated orders. Please archive it instead.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def authorize_user
    authorize current_user, policy_class: ProductPolicy
  end


  def product_params
    params.require(:product).permit(:code, :name, :price_in_currency, :special_offer)
  end
end
