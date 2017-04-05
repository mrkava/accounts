class Auction < ApplicationRecord
  belongs_to :user
  belongs_to :account

  enum status: [:created, :active, :finished]
  enum payment_type: [:immediate_pay, :half_pay, :end_period_pay]

  # monetize :current_price_cents, numericality: { greater_than: 0 }
  monetize :minimum_price_cents, numericality: { greater_than: 0 }
  monetize :final_price_cents, numericality: { greater_than: 0 }
end
