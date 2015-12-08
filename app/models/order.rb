class Order < ActiveRecord::Base
  include Order::RazorpayConcern
  belongs_to :product
  belongs_to :user

  [:authorized, :captured, :refunded, :error].each do |scoped_key|
    scope scoped_key, -> { where('LOWER(status) = ?', scoped_key.to_s.downcase) }
  end
  class << self
    def process_razorpayment(params)
      amount = fetch_payment(params[:payment_id]).amount
      captured = fetch_payment(params[:payment_id]).capture({amount: amount})
      status = fetch_payment(params[:payment_id]).status
      params.merge!({status: status, price: amount})
      return Order.create(params)
    end

    def process_refund(payment_id)
      binding.pry
      fetch_payment(payment_id).refund() #unless fetch_payment(payment_id).status == "refunded"
      record = Order.find_by_payment_id(payment_id)
      record.update_attributes(status: fetch_payment(payment_id).status)
      return record
    end

    def filter(params)
      scope = params[:status] ? Order.send(params[:status]) : Order.authorized
      return scope
    end
  end
end
