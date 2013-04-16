class Admin::DashboardsController < ApplicationController
  before_filter :require_admin

  def manage
    # TODO: ask client if current user should be shown here? if yes, can remove from admin? where to manage >0 admin validation on store?
    @stockers = UserStoreRole.where(store_id: current_store.id,
                                    role: 'stocker')
                                    .map(&:user)
    @admins = UserStoreRole.where(store_id: current_store.id,
                                  role: 'admin')
                                  .map(&:user)

    @admin = User.new
    @stocker = User.new
  end

  def edit
    @store = current_store
  end

  def update
    @store = current_store
    if @store.update_attributes(params[:store])
      redirect_to store_admin_manage_path,
                  notice: "Successfully updated store"
    else
      render action: 'edit'
    end
  end

  def create_role
    email = params[:user][:email]
    role = params[:user][:email]

    if email.blank?
      redirect_to store_admin_manage_path(current_store),
                  notice: 'Please enter an email.'
    elsif user = User.where(email: email).first
      user.send("#{role}_up", current_store)
      Mailer.role_confirmation(user, current_store, role).deliver
      redirect_to store_admin_manage_path(current_store),
                  notice: 'Successfully promoted user.'
    else
      Mailer.role_invitation(email, current_user, current_store).deliver
      redirect_to store_admin_manage_path(current_store),
                  notice: 'Successfully invited user.'
    end
  end

  def destroy_role
    user_id = params[:user_id]
    relationship = UserStoreRole.where(user_id: user_id, store_id: current_store).first
    relationship.destroy
    Mailer.role_revoked(User.find(user_id), current_store).deliver
    redirect_to store_admin_manage_path(current_store),
                notice: "Successfully revoked role."
  end
end
