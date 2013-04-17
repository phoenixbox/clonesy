class UsersController < ApplicationController
  before_filter :next_page, only: [ :create, :update ]

  def new
    @next_page = params[:next_page]
    @user = User.new
  end

  def create
    @user = User.where(email: params[:user][:email]).first

    if @user && @user.orphan?
      @user.update_attributes(params[:user].merge({orphan: false}))
    else
      @user = User.create(params[:user])
    end

    if @user.valid?
      Resque.enqueue(WelcomeEmailJob, @user.email, @user.full_name)

      auto_login(@user)
      redirect_to @next_page || session[:return_to] || root_path,
                  notice: "Welcome, #{@user.full_name}"
    else
      render :action => 'new'
    end
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to profile_path,
                  :notice => "Successfully updated account"
    else
      render :action => 'show'
    end
  end

  def show
    if current_user.present?
      @user = User.find(current_user.id)
      @orders = @user.orders
    else
      redirect_to root_url
    end
  end

  private

  def next_page
    @next_page = params[:user].delete(:next_page)
  end
end
