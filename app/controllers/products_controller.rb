class ProductsController < ApplicationController
  def index
    @products = Product.by_category(params[:category_id]).where(store_id: current_store.id).where(status: 'active').all
    @categories = Category.all
  end

  def show
    session[:return_to] = request.fullpath
    @product = Product.find(params[:id])
  end
end
