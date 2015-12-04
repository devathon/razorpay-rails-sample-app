module Order::RazorpayConcern
  extend ActiveSupport::Concern
  included do
    class << self
      def get_payment_status(raz_payment_id)
        Razorpay::Payment.fetch(raz_payment_id).status
      end

      def get_payment_amount(raz_payment_id)
        Razorpay::Payment.fetch(raz_payment_id).amount
      end

      def capture_payment(raz_payment_id)
        amount = get_payment_amount(raz_payment_id)
        Razorpay::Payment.fetch(raz_payment_id).capture({amount: amount})
      end
    end
  end
end
