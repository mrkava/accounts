class AuctionsController < ApplicationController
  before_action :find_auction, only: [:show, :edit, :update, :destroy,
                                      :start, :buy_immediately]
  before_action :check_created, only: [:edit, :update, :destroy, :start]
  before_action :check_user_access, only: [:edit, :update, :destroy, :start]
  skip_before_action :authenticate_user!, only: [:show, :index]

  def index
    @auctions = Auction.active.page(params[:page]).per(3)
  end

  def show
    check_user_access if @auction.created?
    @bids = @auction.bids.last_bids
  end

  def new
    @auction = current_user.auctions.new
    @accounts = current_user.accounts.opened
    @selected_account_id = params[:selected_account] || @accounts.first.id
  end

  def create
    @auction = current_user.auctions.new(auction_params)
    @auction.current_price = @auction.minimum_price
    if @auction.save
      @auction.account.create_auction!
      redirect_to @auction, notice: 'Auction was created!'
    else
      render 'new'
    end
  end

  def edit; end

  def update
    @auction.current_price = auction_params[:minimum_price]
    if @auction.update_attributes(auction_params)
      flash[:success] = 'Auction was succesfully updated'
      redirect_to @auction
    else
      render 'edit'
    end
  end

  def destroy
    @auction.destroy
    @auction.account.delete_auction!
    redirect_to manage_auctions_auctions_path, notice: 'Auction was deleted'
  end

  def manage_auctions
    @auctions = current_user.auctions
  end

  def start
    @auction.start_auction!
    redirect_back(fallback_location: root_path)
  end

  def buy_immediately
    if @auction.user == current_user
      flash[:alert] = 'You can not buy your own account!'
      redirect_back(fallback_location: root_path) && return
    end
    @auction.immediate_buy(current_user)
    redirect_to manage_accounts_accounts_path, notice: 'Account was bought!'
  end

  private

  def auction_params
    params.require(:auction).permit(:final_price, :minimum_price,
                                    :payment_type, :end_date, :account_id,
                                    :selected_account)
  end

  def find_auction
    @auction = Auction.find(params[:id])
  end

  def check_created
    return if @auction.created?
    redirect_to manage_auctions_auctions_path,
                alert: 'You can not change auction'
  end

  def check_user_access
    return if @auction.user == current_user
    flash[:alert] = 'Access denied!'
    redirect_back(fallback_location: root_path)
  end
end
