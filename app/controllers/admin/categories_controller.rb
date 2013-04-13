class Admin::CategoriesController < ApplicationController
  before_filter :require_admin

  def index
    @categories = current_store.categories.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = current_store.categories.build(params[:category])
    if @category.save
      redirect_to store_admin_categories_path,
      :notice => "Successfully created category."
    else
      render :action => 'new'
    end
  end

  def edit
    @category = current_store.categories.find(params[:id])
  end

  def update
    @category = current_store.categories.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to store_admin_categories_path,
      :notice  => "Successfully updated category."
    else
      render :action => 'edit'
    end
  end
end
