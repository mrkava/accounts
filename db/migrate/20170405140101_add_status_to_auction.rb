class AddStatusToAuction < ActiveRecord::Migration[5.0]
  def change
    add_column :auctions, :status, :integer, default: 0
  end
end
