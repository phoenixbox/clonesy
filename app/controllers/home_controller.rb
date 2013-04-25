class HomeController < ApplicationController

  def show
    @stores = [[Store.first, "Featured Store:"], [Store.last, "Newest Store:"]]
    @products = Product.all.sample(4)
  end

end