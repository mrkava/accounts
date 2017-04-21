class AddCommisionToAuction < ActiveRecord::Migration[5.0]
  def change
    add_column :auctions, :comission, :float
  end
end
