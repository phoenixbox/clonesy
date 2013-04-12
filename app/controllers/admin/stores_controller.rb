class Admin::StoresController < ApplicationController
  before_filter :require_admin

  def index
    @stores = Store.all
  end

  def show
    @store = Store.find(params[:id])
  end

  def new
    @store = Store.new
  end

  def edit
    @store = Store.find(params[:id])
  end

  def create
    @store = Store.new(params[:store])

    if @store.save
      redirect_to store_path(@store.id
        ), notice: "Store is now pending approval"
    else
      render :action => 'new'
    end
  end

  def update
    @store = Store.find(params[:id])
  end

  def destroy
    @store = Store.find(params[:id])
    @store.destroy
  end
end

