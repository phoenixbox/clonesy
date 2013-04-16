class StoresController < ApplicationController
  def index
    @stores = Store.all
  end

  def show
    @store = Store.find(params[:id])
  end

  def new
    @store = Store.new
    @products = current_store.products
  end

  def create
    @store = Store.new(params[:store])

    if @store.save
      redirect_to store_home_path(@store), notice: "Your store is created."
    else
      render action: 'new'
    end
  end
end
