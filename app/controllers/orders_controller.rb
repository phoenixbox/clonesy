class OrdersController < ApplicationController
  before_filter :require_login, only: :index

  def index
    @orders = current_user.orders
  end

  def show
    @order = Order.find_by_guid!(params[:guid])
    @order_items = @order.order_items
  end
end
