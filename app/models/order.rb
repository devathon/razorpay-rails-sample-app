class Order < ActiveRecord::Base
  include Order::RazorpayConcern
  belongs_to :product
  belongs_to :user

  [:authorized, :captured, :refunded, :error].each do |scoped_key|
    scope scoped_key, -> { where('LOWER(status) = ?', scoped_key.to_s.downcase) }
  end

  class << self
    def process_razorpayment(params)
      product = Product.find(params[:product_id])
      razorpay_pmnt_obj = fetch_payment(params[:payment_id])
      status = fetch_payment(params[:payment_id]).status
      if status == "authorized"
        razorpay_pmnt_obj.capture({amount: product.price})
        razorpay_pmnt_obj = fetch_payment(params[:payment_id])
        params.merge!({status: razorpay_pmnt_obj.status, price: product.price})
        Order.create(params)
      else
        raise StandardError, "UNable to capture payment"
      end
    end

    def process_refund(payment_id)
      fetch_payment(payment_id).refund
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
