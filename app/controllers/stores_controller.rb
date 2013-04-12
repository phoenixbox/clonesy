class StoresController < ApplicationController
  # GET /stores
  # GET /stores.json
  def index
    @stores = Store.all
    # render :file => "/stores/not_found_error",  :status => 404
  end

  # GET /stores/1
  def show
    @store = Store.find(params[:id])
  end

  # GET /stores/new
  # GET /stores/new.json
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
    @store = Store.find(params[:id])
  end

  # POST /stores
  # POST /stores.json
  def create
    @store = Store.new(params[:store])

    if @store.save
      redirect_to store_path(@store.id
        ), notice: "Store is now pending approval" 
    else
      render :action => 'new'
    end
  end

  # PUT /stores/1
  # PUT /stores/1.json
  def update
    @store = Store.find(params[:id])
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store = Store.find(params[:id])
    @store.destroy
  end
end
