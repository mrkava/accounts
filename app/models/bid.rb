class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction

  validate :current_price_validation, on: :create

  enum status: [:active, :expired]

  monetize :stake_cents, numericality: { greater_than: 0 }

  scope :last_bids, -> { where(status: :active).order('created_at DESC').limit(4) }

  def current_price_validation
    return if stake_cents - auction.current_price_cents > 99
    errors.add(:stake, 'Your stake must be bigger than current price at least for 1 USD')
  end
end
