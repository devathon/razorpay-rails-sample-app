class AddPaymentIdSellerNameToOrderItems < ActiveRecord::Migration
  def change
  	add_column :order_items,:payment_id, :string
  	add_column :order_items, :seller_id, :integer
  end
end
