class Auction < ApplicationRecord
  monetize :current_price_cents, :final_price_cents, :minimum_price_cents
end
