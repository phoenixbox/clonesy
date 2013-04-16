class Admin::DashboardsController < ApplicationController
  def manage
    @stocker = User.new
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
