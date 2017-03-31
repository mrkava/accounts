class AccountsController < ApplicationController
  before_action :find_account, only: [:show, :edit, :update, :destroy]

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

  def edit; end

  def update
    if @account.update_attributes(account_params)
      flash[:success] = 'Account updated'
      redirect_to manage_accounts_accounts_path
    else
      render 'edit'
    end
  end

  def destroy
    @account.destroy
    flash[:notice] = 'Account was deleted'
    redirect_back(fallback_location: root_path)
  end

  def manage_accounts
    @accounts = current_user.accounts
  end

  private

  def account_params
    params.require(:account).permit(:bookmaker, :age,
                                    :own, :comment)
  end

  def find_account
    @account = Account.find(params[:id])
    return if @account.user == current_user
    redirect_to root_path, alert: 'Access denied!'
  end
end
