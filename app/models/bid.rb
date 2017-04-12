class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction

  validate :current_price_validation

  monetize :stake_cents, numericality: { greater_than: 0 }

  def current_price_validation
    return if stake > auction.current_price
    errors.add(:stake, 'Your stake must be bigger than current price')
  end
end
