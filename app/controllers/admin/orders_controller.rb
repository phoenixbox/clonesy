class Admin::OrdersController < ApplicationController
  before_filter :require_admin

  def index
    @admin_order_view = AdminOrder.from_database(current_store, params[:status])
  end

  def show
    @order = Order.find(params[:id])
    not_authenticated if !@order.stores.include?(current_store)
  end
end
