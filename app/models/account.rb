class Account < ApplicationRecord
  belongs_to :user

  validates :bookmaker, :age, presence: true
  validates_inclusion_of :bookmaker, in: Appvalues['bookmaker']
  validates_inclusion_of :age, in: 1..180
  validates :comment, length: { maximum: 1000 }
end
