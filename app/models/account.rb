class Account < ApplicationRecord
  belongs_to :user
  has_many :auctions

  enum status: [:opened, :auction, :sold]

  validates :bookmaker, :age, presence: true
  validates :bookmaker, inclusion: { in: Appvalues['bookmaker'] }
  validates :age, inclusion: { in: 1..180 }
  validates :comment, length: { maximum: 1000 }

  scope :bought, ->(a) { where(buyer_id: a) }
  scope :opened, -> { where(status: :opened) }

  def to_s
    "#{id} : #{created_at.strftime('%m.%d.%Y, %H:%M')} : #{bookmaker}"
  end
end
