class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def purchase_status
    #binding.pry
    @payment_id = payment_params['razorpay_payment_id']
    payment_status=get_payment_status(@payment_id)
    if payment_status 
      flash.now[:alert] = "Payment failed try again"
      redirect_to root_url
    else
      captured=capture_payment(@payment_id)
      flash.now[:notice] = "Payment successful"
    end
    render 'order_status'
  end


  private
    def payment_params
      params.permit(:razorpay_payment_id, :user_id, :product_id)
    end

end
