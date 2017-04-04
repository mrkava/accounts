class AuctionsController < ApplicationController
  before_action :find_auction, only: [:show, :edit, :update, :destroy]

  def show; end

  def new
    @auction = current_user.auctions.new
    @accounts = current_user.accounts.opened
  end

  def create
    @auction = current_user.auctions.new(auction_params)
    if @auction.save
      redirect_to @auction, notice: 'Auction was created!'
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @auction.update_attributes(auction_params)
      flash[:success] = 'Auction updated'
      redirect_to manage_auctions_auctions_path
    else
      render 'edit'
    end
  end

  def destroy
    @auction.destroy
    flash[:notice] = 'Account was deleted'
    redirect_back(fallback_location: root_path)
  end

  def manage_auctions
    @auctions = current_user.auctions
  end

  private

  def auction_params
    params.require(:auction).permit(:final_price, :minimum_price,
                                    :payment_type, :end_date, :account_id)
  end

  def find_auction
    @auction = Auction.find(params[:id])
  end
end
