class CreateAuctions < ActiveRecord::Migration[5.0]
  def change
    create_table :auctions do |t|
      t.integer :current_price_cents
      t.integer :final_price_cents
      t.integer :minimum_price_cents
      t.integer :payment_type
      t.datetime :end_date
      t.belongs_to :user, index: true
      t.belongs_to :account, index: true

      t.timestamps
    end
  end
end
