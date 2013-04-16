class Admin::DashboardsController < ApplicationController
  before_filter :require_admin

  def manage
    @stockers = UserStoreRole.where(store_id: current_store.id,
                                    role: 'stocker')
                                    .map(&:user)
    @stocker = User.new
  end

  def edit
    @store = current_store
  end

  def update
    @store = current_store
    if @store.update_attributes(params[:store])
      redirect_to store_admin_manage_path,
                  :notice => "Successfully updated store"
    else
      render :action => 'edit'
    end
  end

  def create_stocker
    email = params[:user][:email]
    if email.blank?
      redirect_to store_admin_manage_path(current_store),
                  notice: 'Please enter an email.'
    elsif user = User.where(email: email).first
      user.stocker_up(current_store)
      Mailer.stocker_confirmation(user, current_store).deliver
      redirect_to store_admin_manage_path(current_store),
                  notice: 'Successfully promoted user to stocker.'
    else
      Mailer.stocker_invitation(email, current_user, current_store).deliver
      redirect_to store_admin_manage_path(current_store),
                  notice: 'Successfully invited user.'
    end
  end
end
