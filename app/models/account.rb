class Account < ApplicationRecord
  belongs_to :user

  validates :bookmaker, :age, presence: true
  validates_inclusion_of :bookmaker, in: Appvalues['bookmaker']
end
