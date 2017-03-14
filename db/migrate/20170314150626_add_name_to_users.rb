class AddNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :balance, :decimal, precision: 8, scale: 2, default: 0
  end
end
