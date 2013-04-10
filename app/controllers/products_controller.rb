class ProductsController < ApplicationController
  def index
    @products = Product.by_category(params[:category_id]).where(status: 'active').all
    @categories = Category.all
  end

  def show
    session[:return_to] = request.fullpath
    @product = Product.find(params[:id])
    @ratings = Rating.where(product_id: params[:id])
  end
end
