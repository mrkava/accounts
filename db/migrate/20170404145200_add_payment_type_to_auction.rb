class AddPaymentTypeToAuction < ActiveRecord::Migration[5.0]
  def change
    add_column :auctions, :payment_type, :integer
  end
end
