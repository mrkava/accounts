require 'rails_helper'

RSpec.describe Bid, type: :model do
  let(:user_buyer) { create(:user, balance_cents: 1000) }
  let(:test_auction) do
    create(:auction, current_price_cents: 500, status: :active)
  end

  describe 'Bid create' do
    it 'should validate that new bid price is bigger /
        for more than 99 cents that current price' do
      bid = build(:bid, auction: test_auction, user: user_buyer,
                        stake_cents: test_auction.current_price_cents + 90)
      expect(bid).to be_invalid
    end

    it 'should validate that new bid price is bigger /
        for more than 99 cents that current price' do
      bid = build(:bid, auction: test_auction, user: user_buyer,
                        stake_cents: test_auction.current_price_cents + 100)
      expect(bid).to be_valid
    end

    it 'should set previous bid status to :expired' do
      bid = create(:bid, auction: test_auction, user: user_buyer,
                         stake_cents: test_auction.current_price_cents + 100)
      create(:bid, auction: test_auction, user: user_buyer,
                   stake_cents: test_auction.current_price_cents + 100)
      bid.reload
      expect(bid.status).to eq('expired')
    end

    it 'should be invalid if user available balance is not enough' do
      bid = build(:bid, auction: test_auction, user: user_buyer,
                        stake_cents: user_buyer.balance_cents + 100)
      expect(bid).to be_invalid
    end

    it 'should be valid if user available balance enough' do
      bid = build(:bid, auction: test_auction, user: user_buyer,
                        stake_cents: user_buyer.balance_cents)
      expect(bid).to be_valid
    end

    it 'should correctly validate balance if last bid from same user' do
      create(:bid, auction: test_auction, user: user_buyer,
                   stake_cents: test_auction.current_price_cents + 100)
      bid = build(:bid, auction: test_auction, user: user_buyer,
                        stake_cents: test_auction.current_price_cents + 100)
      expect(bid).to be_valid
    end
  end
end
