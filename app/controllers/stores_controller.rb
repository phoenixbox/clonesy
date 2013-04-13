class StoresController < ApplicationController
  def index
    @stores = Store.all
  end

  def show
    @store = Store.find(params[:id])
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store])

    if @store.save
      redirect_to store_path(@store.id
        ), notice: "Store is now pending approval"
    else
      raise @store.errors.inspect
      render :action => 'new'
    end
  end
end
