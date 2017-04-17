require 'rails_helper'

RSpec.describe Bid, type: :model do
  let(:user_buyer) { create(:user) }
  let(:test_auction) { create(:auction, status: :active) }

  describe 'Bid create' do
    it 'should validate that new bid price is bigger /
        for more than 99 cents that current price' do
      bid = build(:bid, auction: test_auction, user: user_buyer,
                        stake_cents: test_auction.current_price_cents + 90)
      expect(bid).to be_invalid
    end

    it 'should set previous bid status to :expired' do
      bid = create(:bid, auction: test_auction, user: user_buyer)
      create(:bid, auction: test_auction, user: user_buyer)
      bid.reload
      expect(bid.status).to eq('expired')
    end
  end
end
