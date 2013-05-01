class Admin::RolesController < ApplicationController
  before_filter :require_admin

  def create
    email = params[:user][:email]
    role = params[:user][:role]

    if email.blank?
      redirect_to store_admin_manage_path(current_store),
                  notice: 'Please enter an email.'
    elsif user = User.where(email: email).first
      Role.promote(user, current_store, role)
      enqueue_role_confirm(user, current_store, role)
      redirect_to store_admin_manage_path(current_store),
                  notice: 'Successfully promoted user.'
    else
      enqueue_role_invite(email,current_user,current_store,role)
      redirect_to store_admin_manage_path(current_store),
                  notice: 'Successfully invited user.'
    end
  end

  def destroy
    user_id = params[:user_id]
    Role.revoke(user_id, current_store)
    enqueue_role_revoke(user_id, current_store)
    redirect_to store_admin_manage_path(current_store),
                notice: "Successfully revoked role."
  end

private
  def enqueue_role_revoke(user_id, current_store)
    Resque.enqueue(RoleRevokeEmailJob, User.find(user_id), current_store)
  end

  def enqueue_role_confirm(user, current_store, role)
    Resque.enqueue(RoleConfirmEmailJob, user, current_store, role)
  end

  def enqueue_role_invite(email,current_user,current_store,role)
    Resque.enqueue(RoleInviteEmailJob, email, current_user, current_store, role)
  end
end
