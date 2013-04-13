class OrdersController < ApplicationController
  before_filter :require_login

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find_by_id(params[:id])
    @order_items = @order.order_items
  end

  def create
    @order = Order.create_and_charge(cart: current_cart,
                                     user: current_user,
                                     token: params[:stripeToken])
    if @order.valid?
      session[:cart] = current_cart.destroy
      Mailer.order_confirmation(current_user, @order).deliver
      redirect_to account_order_path(@order),
        :notice => "Order submitted!"
    else
      redirect_to store_cart_path(current_store), :notice => "Checkout failed."
    end
  end

  def buy_now
    @order = Order.create_and_charge(cart: Cart.new({params[:order] => '1'}),
                                     user: current_user,
                                     token: params[:stripeToken])
    if @order.valid?
      session[:cart] = current_cart.destroy
      Mailer.order_confirmation(current_user, @order).deliver
      redirect_to account_order_path(@order),
        :notice => "Order submitted!"
    else
      redirect_to :back, :notice => "Checkout failed."
    end
  end
end
