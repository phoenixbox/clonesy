class CollectionsController < ApplicationController

  def index
    @collections = current_user.collections.all
  end

  def new
    @collection = Collection.new
  end

  def update
    collection = Collection.find(params[:id])
    collection.update_attributes(params[:collection])
    redirect_to account_collections_path
  end

  def create
    @collection = Collection.create(params[:collection])
    redirect_to account_collections_path
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

  def add_product
    collection = Collection.find(params[:id])
    collection.add_product(params[:product_id])
    redirect_to :back
  end

  def remove_product
    collection = Collection.find(params[:id])
    collection.remove_product(params[:product_id])
    redirect_to :back 
  end
end