class Auction < ApplicationRecord
  belongs_to :user
  belongs_to :account
  # monetize :current_price_cents, numericality: { greater_than: 0 }
  monetize :minimum_price_cents, numericality: { greater_than: 0 }
  monetize :final_price_cents, numericality: { greater_than: 0 }
end
