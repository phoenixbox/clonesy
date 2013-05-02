class Uber::AccountController < ApplicationController
  before_filter :require_uber

  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to uber_account_path,
                  :notice => "Successfully updated uber account"
    else
      render :action => 'show'
    end
  end
end