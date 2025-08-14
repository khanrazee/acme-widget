class HomeController < ApplicationController
  def index
    @products = Product.limit(10)
  end
end
