class AccountsController < ApplicationController
  before_action :find_account, only: [:show]

  def show; end

  def new
    @account = current_user.accounts.new
  end

  def create
    @account = current_user.accounts.new(account_params)
    if @account.save
      redirect_to @account, notice: 'Account was created!'
    else
      render 'new'
    end
  end

  private

  def account_params
    params.require(:account).permit(:bookmaker, :age,
                                    :own, :comment)
  end

  def find_account
    @account = Account.find(params[:id])
  end
end
