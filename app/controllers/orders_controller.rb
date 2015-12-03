class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def purchase_status
    @payment_id = payment_params['razorpay_payment_id']
    @amount = get_payment_amount(@payment_id)
    payment_status=get_payment_status(@payment_id)
    @status = ""
    if payment_status 
      flash.now[:alert] = "Payment failed try again"
      redirect_to root_url
      @status = "failed"
    else
      captured=capture_payment(@payment_id)
      flash.now[:notice] = "Payment successful"
      @status = "successful"
    end
    @order = Order.create(product_id: payment_params[:product_id],payment_id: payment_params[:razorpay_payment_id],status: @status,price: @amount)
    #render 'order_status'
    redirect_to :action => "show", :id => @order.id
  end

  def show
    @order = Order.find_by_id(params[:id])
    @product = Product.find_by_id(@order.product_id)
  end

  def index
    @orders = Order.all
    @success_orders=Order.where(:status => "captured")
    @refunded_orders=Order.where(:status => "refunded")
    @failed_orders=Order.where(:status => "failed")
  end

  private
    def payment_params
      params.permit(:razorpay_payment_id, :user_id, :product_id,:price)
    end

end
