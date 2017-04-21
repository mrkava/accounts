class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  has_many :accounts
  has_many :auctions
  has_many :bids

  validates :name, :email, :password, presence: true, on: :create

  validates :name, length: { minimum: 2, maximum: 50 }

  validates :password, length: { minimum: 6 }, on: :create

  monetize :balance_cents

  def available_balance
    balance_cents - bids.active.sum(:stake_cents) -
      auctions.active.count * Appvalues['auction_minimum_comission']
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end
end
