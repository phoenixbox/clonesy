class ProductsController < ApplicationController
  before_filter :require_current_store

  def index
    @products = current_store.products.includes(:store)
                  .by_category(params[:category_id]).active
                  .page(params[:page]).per(20)
    @categories = current_store.categories
    current_store.increase_popularity(request.remote_ip)
    session[:return_to] = request.fullpath
  end

  def show
    @collections = Collection.for_user(current_user)
    @product = current_store.products.find(params[:id])
    @product.increase_popularity
    session[:return_to] = request.fullpath
  end
end
