class Admin::DashboardsController < ApplicationController
  before_filter :require_admin

  def manage
    @admins = UserStoreRole.where(store_id: current_store.id,
                                  role: 'admin')
                                  .map(&:user)

    @admin = User.new
  end

  def edit
    @themes = Store.themes
    @store = current_store
  end

  def update
    @store = current_store
    if @store.update_attributes(params[:store])
      redirect_to store_admin_manage_path(current_store),
                  notice: "Successfully updated store"
    else
      render action: 'edit'
    end
  end
end
