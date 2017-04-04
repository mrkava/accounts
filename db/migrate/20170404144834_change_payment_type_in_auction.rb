class ChangePaymentTypeInAuction < ActiveRecord::Migration[5.0]
  def change
    remove_column :auctions, :payment_type
  end
end
