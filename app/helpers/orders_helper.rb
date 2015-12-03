module OrdersHelper
  def get_payment_status(raz_payment_id)
    Razorpay::Payment.fetch(raz_payment_id).status == "failed"
  end

  def capture_payment(raz_payment_id)
    amount=Razorpay::Payment.fetch(raz_payment_id).amount
    Razorpay::Payment.fetch(raz_payment_id).capture({amount: amount})
  end


end
