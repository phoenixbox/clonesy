class Admin::RolesController < ApplicationController
  before_filter :require_admin

  def create
    email = params[:user][:email]
    role = params[:user][:role]

    if email.blank?
      redirect_to store_admin_manage_path(current_store),
                  notice: 'Please enter an email.'
    elsif user = User.where(email: email).first
      user.send("#{role}_up", current_store)
      # Mailer.role_confirmation(user, current_store, role).deliver
      Resque.enqueue(RoleConfirmEmailJob, user, current_store, role)
      redirect_to store_admin_manage_path(current_store),
                  notice: 'Successfully promoted user.'
    else
      Mailer.role_invitation(email, current_user, current_store, role).deliver
      redirect_to store_admin_manage_path(current_store),
                  notice: 'Successfully invited user.'
    end
  end

  def destroy
    user_id = params[:user_id]
    relationship = UserStoreRole.where(user_id: user_id, store_id: current_store).first
    relationship.destroy
    Mailer.revoke_role(User.find(user_id), current_store).deliver
    redirect_to store_admin_manage_path(current_store),
                notice: "Successfully revoked role."
  end
end
