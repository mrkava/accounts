class Auction < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :account
  has_many :bids

  enum status: [:created, :active, :finished]
  enum payment_type: [:immediate_pay, :half_pay, :end_period_pay]

  validates :payment_type, :final_price, :minimum_price, :end_date,
            presence: true
  validate :end_date_validation, :price_validation

  scope :active, -> { where(status: :active) }

  monetize :current_price_cents, numericality: { greater_than: 0 }
  monetize :minimum_price_cents, numericality: { greater_than: 0 }
  monetize :final_price_cents, numericality: { greater_than: 0 }

  PAYMENT_TYPES = { 'Pay immediately after auction end' => 'immediate_pay',
                    'Pay 50% immediately and 50% after 30 days' => 'half_pay',
                    'Pay 30 days after auction end' => 'end_period_pay' }.freeze

  aasm column: :status, enum: true do
    state :created, initial: true
    state :active, :finished

    event :start_auction do
      transitions from: :created, to: :active
    end

    event :finish_auction do
      transitions from: :active, to: :finished
    end
  end

  def close_auction
    self.finish_auction!
    if self.bids.any?
      self.account.update_attributes(buyer_id: self.bids.last.user.id, status: :sold)
    else
      self.account.update_attributes(status: :opened)
    end
  end

  private

  def end_date_validation
    return unless end_date.present? && end_date < Time.current + 24.hours
    errors.add(:end_date, 'Auction end must be at least 24 hours from now')
  end

  def price_validation
    return unless final_price.present? && minimum_price.present? &&
                  minimum_price >= final_price
    errors.add(:minimum_price, 'Final price must be bigger than minimum price')
  end
end
