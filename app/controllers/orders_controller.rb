class OrdersController < ApplicationController
  before_filter :require_login, only: :index

  def index
    @orders = current_user.orders.page(params[:page]).per(20)
  end

  def show
    unless @order = Order.find_by_guid(params[:guid])
      redirect_to :back
      return
    end
    @order_items = @order.order_items
  end
end
