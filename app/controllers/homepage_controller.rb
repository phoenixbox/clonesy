class HomepageController < ApplicationController

  def show
    @featured_products = Product.featured
    @featured_store = Store.featured
    @recent_store = Store.recent
    @recently_listed = Product.recent
  end
end
