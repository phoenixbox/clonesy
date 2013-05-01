class CollectionsController < ApplicationController
  before_filter :require_login
  before_filter :find_product, only: [ :edit,
                                       :update,
                                       :destroy,
                                       :add_product,
                                       :remove_product ]


  def index
    @collections = current_user.collections
                      .includes(:products)
                      .select { |collection| collection.name != "favorites" }
  end

  def show
    @collection = current_user.collections.includes(:products).find(params[:id])
    render 'show'
  end

  def new
    @product_to_add = params[:product_id]
    @collection = Collection.new
  end

  def create
    product_id = params[:collection].delete(:product_id)
    @collection = current_user.collections.build(params[:collection])

    if @collection.save
      @collection.add_product(product_id) if product_id.present?
      redirect_to session[:return_to] || account_collection_path(@collection),
                  notice: "Collection created!"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    flash[:message] = if @collection.update_attributes(params[:collection])
      'Collection updated'
    else
      'Update failed'
    end

    redirect_to account_collection_path(@collection)
  end

  def destroy
    @collection.destroy
    redirect_to account_collections_path,
                notice: "Collection deleted"
  end

  def add_product
    @collection.add_product(params[:product_id])
    redirect_to :back,
                notice: "Product added to the #{@collection.name} collection!"
  end

  def remove_product
    @collection.remove_product(params[:product_id])
    redirect_to :back
  end

private
  def find_product
    @collection = current_user.collections.find(params[:id])
  end
end
