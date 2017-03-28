class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :bookmaker
      t.integer :age
      t.boolean :own
      t.text :comment

      t.timestamps
    end
  end
end
