class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def purchase_status
    #binding.pry
    @status = "Successfully placed.."
    @payment_id = params['razorpay_payment_id']
    render 'order_status'
  end

end
