namespace :auctions do
  desc 'Close finished auctions'
  task close: :environment do
    Auction.yesterday.active.find_each(&:close_auction)
  end
end
