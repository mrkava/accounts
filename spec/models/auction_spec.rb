require 'rails_helper'

RSpec.describe Auction, type: :model do
  let(:user_seller) { create(:user) }
  let(:user_buyer) { create(:user) }
  let(:test_account) { create(:account, user: user_seller, status: :auction) }
  let(:test_auction) do
    create(:auction, account: test_account, user: user_seller, status: :active)
  end

  describe 'Close_auction' do
    it 'should change auction status to finished' do
      test_auction.close_auction
      expect(test_auction.status).to eq('finished')
    end

    it 'should set buyer_id and status :sold to account if there are bids' do
      bid = create(:bid, auction: test_auction, user: user_buyer)
      bid.reload
      test_auction.close_auction
      test_account.reload
      expect(test_account.status).to eq('sold')
      expect(test_account.buyer_id).to eq(user_buyer.id)
    end

    it 'should set status :opened to account /
        and not set buyer_id if there no bids' do
      test_auction.close_auction
      test_account.reload
      expect(test_account.status).to eq('opened')
      expect(test_account.buyer_id).to eq(0)
    end

    it 'should set last bid status to :final' do
      bid = create(:bid, auction: test_auction, user: user_buyer)
      bid2 = create(:bid, auction: test_auction, user: user_buyer)
      bid.reload
      test_auction.close_auction
      test_account.reload
      expect(bid.status).to eq('expired')
      bid2.reload
      expect(bid2.status).to eq('final')
    end
  end

  describe 'immediate_buy' do
    before(:each) do
      test_auction.immediate_buy(user_buyer)
    end

    it 'should create bid with final price' do
      expect(test_auction.bids.last.stake).to eq(test_auction.final_price)
      expect(test_auction.bids.last.status).to eq('final')
    end

    it 'should close auction' do
      expect(test_auction.status).to eq('finished')
      expect(test_account.status).to eq('sold')
      expect(test_account.buyer_id).to eq(user_buyer.id)
    end
  end
end
