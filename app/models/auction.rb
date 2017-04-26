class Auction < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :account
  has_many :bids

  enum status: [:created, :active, :finished, :closed]
  enum payment_type: [:immediate_pay, :half_pay, :end_period_pay]

  validates :payment_type, :final_price, :minimum_price, :end_date,
            presence: true
  validate :end_date_validation, :price_validation

  before_save do
    self.comission = calculate_comission
  end

  scope :active, -> { where(status: :active) }
  scope :make_closed, -> { where('end_date < ? and status = ?', Date.today - 24.hours, 'finished') }
  scope :yesterday, -> { where('end_date < ?', Date.today) }

  monetize :current_price_cents, numericality: { greater_than: 0 }
  monetize :minimum_price_cents, numericality: { greater_than: 0 }
  monetize :final_price_cents, numericality: { greater_than: 0 }

  PAYMENT_TYPES = { 'Pay immediately after auction end' => 'immediate_pay',
                    'Pay 50% immediately and 50% after 30 days' => 'half_pay',
                    'Pay 30 days after auction end' => 'end_period_pay' }.freeze

  aasm column: :status, enum: true, skip_validation_on_save: true do
    state :created, initial: true
    state :active, :finished, :closed

    event :start_auction do
      transitions from: :created, to: :active
    end

    event :finish_auction_event do
      transitions from: :active, to: :finished
    end

    event :close_auction_event do
      transitions from: :finished, to: :closed
    end
  end

  def close_auction
    close_auction_event!
    if bids.any?
      account.update_attributes(buyer_id: bids.last.user.id, status: :sold)
      bids.last.update_attributes(status: :final)
    else
      account.update_attributes(status: :opened)
    end
  end

  def finish_auction
    self.status = :finished
    save(validate: false)
  end

  def immediate_buy(user)
    return false if user.available_balance_with_auction(id) < final_price_cents
    bids.create(user_id: user.id, stake: final_price)
    finish_auction
  end

  def calculate_comission
    payment_type_multiplier = case payment_type
                              when 'immediate_pay'
                                2
                              when 'half_pay'
                                1.5
                              else
                                1
                              end
    Appvalues['auction_standard_commision'] * payment_type_multiplier
  end

  private

  def end_date_validation
    return unless end_date.present? && end_date < DateTime.now.tomorrow.to_date
    errors.add(:end_date, 'Auction end must be at least 24 hours from now')
  end

  def price_validation
    return unless final_price.present? && minimum_price.present? &&
                  minimum_price >= final_price
    errors.add(:minimum_price, 'Final price must be bigger than minimum price')
  end
end
