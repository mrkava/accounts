namespace :auctions do
  desc 'Close finished auctions'
  task close: :environment do
    Auction.yesterday.active.find_each do |auction|
      auction.close_auction
    end
  end
end