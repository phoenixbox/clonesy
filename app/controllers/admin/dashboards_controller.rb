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
end
