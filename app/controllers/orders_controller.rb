class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def purchase_status
    binding.pry
    @payment_id = payment_params['razorpay_payment_id']
    @amount = get_payment_amount(@payment_id)
    captured=capture_payment(@payment_id)
    @status=get_payment_status(@payment_id)
    @order = Order.create(product_id: payment_params[:product_id],payment_id: payment_params[:razorpay_payment_id],status: @status,price: @amount)
    redirect_to :action => "show", :id => @order.id
  end

  def show
    @order = Order.find_by_id(params[:id])
    @product = Product.find_by_id(@order.product_id)
  end

  def index
    @orders = Order.all
    @success_orders=Order.where(:status => "authorized")
    @captured_orders=Order.where(:status => "captured")
    @failed_orders=Order.where(:status => "failed")
  end

  private
    def payment_params
      params.permit(:razorpay_payment_id, :user_id, :product_id,:price)
    end

end
