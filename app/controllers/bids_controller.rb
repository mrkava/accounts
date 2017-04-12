class BidsController < ApplicationController
  def new; end

  def create
    @auction = Auction.find(params[:auction_id])
    @bid = @auction.bids.new(bid_params)
    @bid.user = current_user

    if @bid.save
      @auction.update_attributes(current_price: @bid.stake)
      redirect_to auctions_path, notice: 'Bid was created!'
    else
      redirect_to auctions_path,
                  notice: "Bid was NOT created! \
                          #{@bid.errors.messages[:stake].first}"
    end
  end

  private

  def bid_params
    params.require(:bid).permit(:stake)
  end
end
