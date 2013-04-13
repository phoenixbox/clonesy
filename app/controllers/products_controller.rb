class ProductsController < ApplicationController
  def index
    @products = Product.by_category(params[:category_id]).where(store_id: current_store.id).where(status: 'active').all
    @categories = Category.all
  end

  def show
    @store = current_store
    @product = Product.find(params[:id])
    session[:return_to] = request.fullpath
  end
end