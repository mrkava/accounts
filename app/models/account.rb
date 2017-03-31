class Account < ApplicationRecord
  belongs_to :user

  validates :bookmaker, :age, presence: true
  validates :bookmaker, inclusion: { in: Appvalues['bookmaker'] }
  validates :age, inclusion: { in: 1..180 }
  validates :comment, length: { maximum: 1000 }
end
