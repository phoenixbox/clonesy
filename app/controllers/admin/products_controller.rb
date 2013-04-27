class Admin::ProductsController < ApplicationController
  before_filter :require_admin
  before_filter :find_product, only: [ :edit,
                                       :update,
                                       :destroy,
                                       :toggle_status ]

  def index
    @products = current_store.products.order('created_at DESC')
                             .page(params[:page]).per(20)
  end

  def new
    @product = Product.new
  end

  def create
    images = params[:product].delete(:images)
    @product = current_store.products.new(params[:product])

    if @product.save
      Image.process_blob(images.values, @product) if images

      redirect_to store_admin_products_path(current_store),
        :notice => "Successfully created product."
    else
      render :action => 'new', :notice  => "Product creation failed."
    end
  end

  def edit
  end

  def update
    if @product.update_attributes(params[:product])
      redirect_to store_admin_products_path(current_store),
        :notice  => "Successfully updated product."
    else
      render :action => 'edit', :notice  => "Update failed."
    end
  end

  def destroy
    @product.destroy
    redirect_to store_admin_products_path(current_store),
      :notice => "Successfully destroyed product."
  end

  def toggle_status
    @product.toggle_status
    redirect_to store_admin_products_path(current_store),
                :notice  => "Product status successfully set to '#{@product.status}'."
  end

  private
  def find_product
    @product = current_store.products.find(params[:id])
  end
end
