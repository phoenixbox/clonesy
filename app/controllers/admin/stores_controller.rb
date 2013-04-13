class Admin::StoresController < ApplicationController
  before_filter :require_admin

  def index
    @stores = Store.all
  end

  def show
    @store = Store.find_by_path!(params[:store_path])
  end

  def new
    @store = Store.new
  end

  def edit
    @store = Store.find_by_path!(params[:store_path])
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
end

