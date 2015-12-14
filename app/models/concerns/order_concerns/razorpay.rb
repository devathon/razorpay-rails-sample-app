module OrderConcerns::Razorpay
  extend ActiveSupport::Concern
  included do
    class << self
      def fetch_payment(raz_payment_id)
        Razorpay::Payment.fetch(raz_payment_id)
      end
    end
  end
end
