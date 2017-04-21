class ChangeBalanceToBalanceCentsInUser < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :balance, :balance_cents
  end
end
