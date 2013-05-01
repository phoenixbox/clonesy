class Uber::OrdersController < ApplicationController
  before_filter :require_uber

  def index
    @orders = Order.order('created_at DESC').page(params[:page]).per(20)
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])

    if params[:update_status]
      @order.update_status
    end
    redirect_to :back
  end
end
