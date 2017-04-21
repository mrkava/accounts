class ChangeBalanceCentsTypeInUser < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :balance_cents, :integer, default: 0
  end
end
