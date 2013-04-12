class Uber::StoresController < ApplicationController
  before_filter :require_uber

  def index
    @stores = Store.all
  end

  def approve
    @store = Store.find(params[:id])
    @store.status = 'online'
    if @store.save
      redirect_to uber_dashboard_path, :notice  => "Store is now online."
    else
      head 400
    end
  end

  def disapprove
    @store = Store.find(params[:id])
    @store.status = 'disapproved'
    if @store.save
      redirect_to uber_dashboard_path, :notice  => "Store is now disapproved."
    else
      head 400
    end
  end

  def toggle_status
    @store = Store.find(params[:id])
    if @store.toggle_status
      redirect_to uber_dashboard_path,
        :notice  => "Store status successfully set to '#{@store.status}'."
    else
      head 400
    end
  end

  def destroy
    @store = Store.find(params[:id])
    @store.destroy
  end
end

