class ChangeEndDateTypeInAuction < ActiveRecord::Migration[5.0]
  def change
    change_column :auctions, :end_date, :date
  end
end
