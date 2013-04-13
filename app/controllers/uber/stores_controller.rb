class Uber::StoresController < ApplicationController
  before_filter :require_uber

  def index
    @stores = Store.approved.order("created_at DESC").all
  end

  def approve
    @store = Store.find(params[:id])
    @store.status = 'online'
    if @store.save
      redirect_to uber_stores_path, :notice  => "Store is now online."
    else
      head 400
    end
  end

  def decline
    @store = Store.find(params[:id])
    @store.status = 'declined'
    if @store.save
      redirect_to uber_stores_path, :notice  => "Store is declined."
    else
      head 400
    end
  end

  def toggle_online_status
    @store = Store.find(params[:id])
    if @store.toggle_online_status(:uber)
      redirect_to uber_stores_path,
        :notice  => "Store status successfully set to '#{@store.status}'."
    else
      head 400
    end
  end
end

