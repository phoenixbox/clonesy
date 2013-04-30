class Admin::DashboardsController < ApplicationController
  before_filter :require_admin

  def manage
    @admins = UserStoreRole.admins(current_store)
    @admin = User.new
  end

  def edit
  end

  def update
    if current_store.update_attributes(params[:store])
      redirect_to store_admin_manage_path(current_store),
                  notice: "Successfully updated store"
    else
      render action: 'edit'
    end
  end
end
