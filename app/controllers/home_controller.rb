class HomeController < ApplicationController

  def show
    @stores = [[Store.first, "Featured Store:"], [Store.last, "Newest Store:"]]
    @products = Product.all.sample(4)
    @listings = @products + Product.all.sample(2)
  end

end