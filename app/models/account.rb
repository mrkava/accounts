class Account < ApplicationRecord
  include AASM

  belongs_to :user
  has_many :auctions

  enum status: [:opened, :auction, :sold]

  validates :bookmaker, :age, presence: true
  validates :bookmaker, inclusion: { in: Appvalues['bookmaker'] }
  validates :age, inclusion: { in: 1..180 }
  validates :comment, length: { maximum: 1000 }

  scope :bought, ->(a) { where(buyer_id: a) }
  scope :opened, -> { where(status: :opened) }

  aasm column: :status, enum: true do
    state :opened, initial: true
    state :auction, :sold

    event :create_auction do
      transitions from: :opened, to: :auction
    end

    event :delete_auction do
      transitions from: :auction, to: :opened
    end

    event :complete_auction do
      transitions from: :auction, to: :sold
    end
  end

  def to_s
    "#{id} : #{created_at.strftime('%m.%d.%Y, %H:%M')} : #{bookmaker}"
  end
end
