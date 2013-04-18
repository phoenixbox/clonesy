class SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:sessions][:email],
                 params[:sessions][:password],
                 params[:sessions][:remember_me]
                 )
    if user
      next_page = params[:sessions][:next_page]
      redirect_to next_page || session[:return_to] || root_path,
        notice: 'Logged in!'
    else
      flash.alert = 'Username or password was invalid'
      redirect_to login_path
    end
  end

  def destroy
    logout
    redirect_to root_url, notice: 'Logged out!'
  end
end
