class CollectionsController < ApplicationController

  def index
    @collections = Collection.all
  end

  def new
  end

  def update
    collection = Collection.find(params[:id])
    collection.update_attributes(params[:collection])
    redirect_to account_collections_path
  end

  def create
    @collection = Collection.create(params[:collection])
    render 'index'
  end

  def show
    @collection = Collection.find(params[:id])
    render 'show'
  end

  def destroy
    collection = Collection.find(params[:id])
    collection.destroy
    redirect_to account_collections_path
  end


end