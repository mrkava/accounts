class BidsController < ApplicationController
  before_action :check_user_access, only: [:create]
  before_action :check_auction_status, only: [:create]

  def create
    @bid = @auction.bids.new(bid_params)
    @bid.user = current_user
    @bid.stake = @auction.final_price if @bid.stake > @auction.final_price

    respond_to do |format|
    if @bid.save
      flash[:notice] = 'Bid was created!'
      finish_auction_when_stake_over_final_price && return
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    else
      flash[:alert] = "Bid was NOT created! Errors:
                       #{@bid.errors.messages[:stake].join(', ')}"
      format.html { redirect_back(fallback_location: root_path) }
    end
    end
  end

  private

  def check_user_access
    @auction = Auction.find(params[:auction_id])
    return if @auction.user != current_user
    flash[:alert] = 'You can not buy your own account!'
    redirect_back(fallback_location: root_path)
  end

  def check_auction_status
    return if @auction.active?
    flash[:alert] = 'You can not make bids in not active auctions!'
    redirect_back(fallback_location: root_path)
  end

  def finish_auction_when_stake_over_final_price
    return if @bid.stake < @bid.auction.final_price
    @bid.auction.finish_auction
    redirect_to @bid.auction,
                notice: 'You won the auction! You need to close auction
                           after seller sends you account details'
  end

  def bid_params
    params.require(:bid).permit(:stake)
  end
end
