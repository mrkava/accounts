class Auction < ApplicationRecord
  belongs_to :user
  belongs_to :account

  enum status: [:created, :active, :finished]
  enum payment_type: [:immediate_pay, :half_pay, :end_period_pay]

  validates :payment_type, :final_price, :minimum_price, :end_date, presence: true

  validate :end_date_validation, :price_validation


  # monetize :current_price_cents, numericality: { greater_than: 0 }
  monetize :minimum_price_cents, numericality: { greater_than: 0 }
  monetize :final_price_cents, numericality: { greater_than: 0 }

  PAYMENT_TYPES = { 'Pay immediately after auction end' => 'immediate_pay',
                    'Pay 50% immediately and 50% after 30 days' => 'half_pay',
                    'Pay 30 days after auction end' => 'end_period_pay'
  }

  def end_date_validation
    if end_date.present? && end_date < Time.now + 24.hours
      errors.add(:end_date, 'Auction end must be at least 24 hours from now')
    end
  end

  def price_validation
    if final_price.present? && minimum_price.present? && minimum_price >= final_price
      errors.add(:minimum_price, 'Final price must be bigger than minimum price')
    end
  end
end
