class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction

  after_create do
    auction.update_attributes(current_price: stake)
    if auction.bids.count > 1
      auction.bids.second_to_last.update_attributes(status: :expired)
    end
  end

  validate :current_price_validation, :balance_validation, on: :create

  enum status: [:active, :expired, :final]

  monetize :stake_cents, numericality: { greater_than: 0 }

  scope :last_bids, -> { order('created_at DESC').limit(4) }
  scope :active, -> { where(status: :active) }

  private

  def balance_validation
    return if user.available_balance_with_auction(auction.id) >= stake_cents
    errors.add(:stake, 'You have not enough money on
                        your balance to make this bid!')
  end

  def current_price_validation
    return if stake_cents - auction.current_price_cents > 99 ||
              stake_cents >= auction.final_price_cents
    errors.add(:stake, 'Your stake must be bigger than current price
                        at least for 1 USD')
  end
end
