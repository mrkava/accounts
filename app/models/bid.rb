class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction

  after_create do
    auction.update_attributes(current_price: stake)
    if auction.bids.count > 1
      auction.bids.last(2).first.update_attributes(status: :expired)
    end
  end

  validate :current_price_validation, on: :create

  enum status: [:active, :expired, :final]

  monetize :stake_cents, numericality: { greater_than: 0 }

  scope :last_bids, -> { order('created_at DESC').limit(4) }

  def current_price_validation
    return if stake_cents - auction.current_price_cents > 99 ||
              stake_cents >= auction.final_price_cents
    errors.add(:stake, 'Your stake must be bigger than current price
                        at least for 1 USD')
  end
end
