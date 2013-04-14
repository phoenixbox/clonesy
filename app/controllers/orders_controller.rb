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
    order = create_order_and_pay(current_cart)
    if order.valid?
      current_cart.destroy

      redirect_to account_order_path(order),
        :notice => "Order submitted!"
    else
      redirect_to store_cart_path(current_store), :notice => "Checkout failed."
    end
  end

  def buy_now
    cart = Cart.new(params[:order] => '1')

    order = create_order_and_pay(cart.items)
    if order.valid?
      redirect_to account_order_path(order),
        :notice => "Order submitted!"
    else
      redirect_to :back, :notice => "Checkout failed."
    end
  end

protected

  def create_order_and_pay(cart_items)
    Order.create_pending_order(current_user, cart_items).tap do |order|
      Payment.create_with_charge token: params[:stripeToken],
                                 price: order.total,
                                 email: order.user.email,
                                 order: order

      if order.valid?
        Mailer.order_confirmation(current_user, order).deliver
      end
    end
  end

end
