class BidsController < ApplicationController
  before_action :check_user_access, only: [:create]

  def new; end

  def create
    @auction = Auction.find(params[:auction_id])
    @last_bid = @auction.bids.last
    @bid = @auction.bids.new(bid_params)
    @bid.user = current_user

    if @bid.save
      @auction.update_attributes(current_price: @bid.stake)
      @last_bid.update_attributes(status: :expired) if @last_bid.present?
      flash[:notice] = 'Bid was created!'
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "Bid was NOT created! #{@bid.errors.messages[:stake].first}"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def check_user_access
    @auction = Auction.find(params[:auction_id])
    return if @auction.user != current_user
    flash[:alert] = 'You can not buy your own account!'
    redirect_back(fallback_location: root_path)
  end

  def bid_params
    params.require(:bid).permit(:stake)
  end
end
