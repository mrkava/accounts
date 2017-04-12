class CreateBids < ActiveRecord::Migration[5.0]
  def change
    create_table :bids do |t|
      t.integer :stake_cents
      t.belongs_to :user, index: true
      t.belongs_to :auction, index: true

      t.timestamps
    end
  end
end
