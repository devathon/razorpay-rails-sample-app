class ProductsController < ApplicationController
  def index
  	@product = Product.first
  	# @seller = Seller.find_by_id(@product.seller_id)
  end

  def automatic
    @product = Product.first
    # @seller = Seller.find_by_id(@product.seller_id)
  end

end
