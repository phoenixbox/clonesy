class CartsController < ApplicationController
  def show
  end

  def update
    current_cart.update(params[:carts])
    redirect_to(:back)
  end

  def remove_item
    current_cart.remove_item(params[:product_id])
    redirect_to(:back)
  end

  def destroy
    current_cart.destroy
    redirect_to root_path, notice: "Cart cleared."
  end
end
