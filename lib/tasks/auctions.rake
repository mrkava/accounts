namespace :auctions do
  desc 'Close finished auctions'
  task close: :environment do
    Auction.make_closed.find_each(&:close_auction)
  end
  task finish: :environment do
    Auction.yesterday.active.find_each(&:finish_auction)
  end
end
