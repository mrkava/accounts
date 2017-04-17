class BidsController < ApplicationController
  before_action :check_user_access, only: [:create]
  before_action :check_auction_status, only: [:create]

  def new; end

  def create
    @bid = @auction.bids.new(bid_params)
    @bid.user = current_user

    if @bid.save
      flash[:notice] = 'Bid was created!'
    else
      flash[:alert] = "Bid was NOT created! #{@bid.errors.messages[:stake].first}"
    end

    redirect_back(fallback_location: root_path)
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
    flash[:alert] = 'You can make bids in not active auctions!'
    redirect_back(fallback_location: root_path)
  end

  def bid_params
    params.require(:bid).permit(:stake)
  end
end
