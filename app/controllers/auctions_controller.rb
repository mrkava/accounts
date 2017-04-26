class AuctionsController < ApplicationController
  before_action :find_auction, only: [:show, :edit, :update, :destroy,
                                      :start, :buy_immediately, :close]
  before_action only: [:edit, :update, :destroy, :start] do
    check_status('created')
  end
  before_action only: [:close] do
    check_status('finished')
    check_user_access(@auction.bids.last.user)
  end
  before_action only: [:edit, :update, :destroy, :start] do
    check_user_access(@auction.user)
  end
  before_action :check_own_account, only: [:buy_immediately]
  skip_before_action :authenticate_user!, only: [:show, :index]

  def index
    @auctions = Auction.active.page(params[:page]).per(5)
  end

  def show
    check_user_access(@auction.user) if @auction.created?
    @bids = @auction.bids.last_bids
    @current_winner = @bids.any? && @bids.last.user == current_user
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
    if @auction.immediate_buy(current_user)
      redirect_to bought_accounts_accounts_path,
                  notice: 'You won the auction! You need to close auction
                           after seller sends you account details'
    else
      flash[:alert] = 'You have not enough money on
                        your balance to buy this account!'
      redirect_back(fallback_location: root_path)
    end
  end

  def close
    @auction.close_auction
    redirect_to bought_accounts_accounts_path,
                notice: 'Auction was closed! You have bought an account'
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

  def check_own_account
    return unless @auction.user == current_user
      flash[:alert] = 'You can not buy your own account!'
      redirect_back(fallback_location: root_path)
  end

  def check_status(status)
    return if @auction.status == status
    redirect_to manage_auctions_auctions_path,
                alert: 'You can not change auction'
  end

  def check_user_access(user)
    return if user == current_user
    flash[:alert] = 'Access denied!'
    redirect_back(fallback_location: root_path)
  end
end
