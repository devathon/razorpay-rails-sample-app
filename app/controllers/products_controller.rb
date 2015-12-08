class ProductsController < ApplicationController
  def index
  	#@products = Product.all.page(params[:page]).per(10)
  	# @seller = Seller.find_by_id(@product.seller_id)
    @product=Product.first
    @product2=Product.second
  end

  def show 
    @product = Product.find_by(id: params['id'])
    if params['mode'] == 'automatic'
      render 'automatic'
    else
      render 'manual'
    end
  end

end
