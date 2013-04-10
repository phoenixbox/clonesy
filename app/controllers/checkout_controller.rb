class CheckoutController < ApplicationController
  before_filter :find_or_create_cart

  def show
  end
end
