class OrdersController < ApplicationController
  include Order::RazorpayConcern
  skip_before_action :verify_authenticity_token
  def purchase_status
    begin
      @order = Order.process_razorpayment(payment_params)
      redirect_to :action => "show", :id => @order.id
    rescue Exception => e
      # use case either refund immediatly or notify admin / client.
      redirect_to root_path, flash: "Unable to process payment, please check with our customer service."
    end
  end

  def show
    @order = Order.find_by_id(params[:id])
  end
  
  def index
    @orders = Order.filter(filter_params).page(params[:page]).per(20)
  end

  def refund
    payment_id = Order.find_by_id(params[:id]).payment_id
    @order = Order.process_refund(payment_id)
    redirect_to :action => "show", :id => @order.id
  end

  private
    def payment_params
      p = params.permit(:payment_id, :user_id, :product_id, :price, :razorpay_payment_id)
      p.merge!({payment_id: p.delete(:razorpay_payment_id) || p[:payment_id]})
      p
    end

    def filter_params
      params.permit(:status, :page)
    end

end
