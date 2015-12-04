class Order < ActiveRecord::Base
  include Order::RazorpayConcern
  belongs_to :product

  [:authorized, :captured, :refunded, :error].each do |scoped_key|
    scope scoped_key, -> { where('LOWER(status) = ?', scoped_key.to_s.downcase) }
  end
  class << self
    def process_razorpayment(params)
      amount = get_payment_amount(params[:payment_id])
      captured = capture_payment(params[:payment_id])
      status = get_payment_status(params[:payment_id])
      params.merge!({status: status, price: amount}) && params.except!(:user_id)
      return Order.create(params)
    end

    def filter(params)
      scope = params[:status] ? Order.send(params[:status]) : Order.authorized
      return scope
    end
  end
end
