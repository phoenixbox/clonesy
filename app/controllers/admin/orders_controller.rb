class Admin::OrdersController < ApplicationController
  before_filter :require_admin

  def index
    @count = current_user.orders.count
    @orders = current_user.orders.by_status(params[:status]).all
    @statuses = current_user.orders.count(group: :status)
    @active_tab = params[:status] || 'all'
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def update
    @order = current_user.orders.find(params[:id])
    if params[:update_status]
      @order.update_status
    end
    redirect_to(:back)
  end
end
