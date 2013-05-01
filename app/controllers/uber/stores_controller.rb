class Uber::StoresController < ApplicationController
  before_filter :require_uber
  before_filter :find_store, only: [ :approve, :decline, :toggle_online_status ]

  def index
    @stores = Store.approved.order("created_at DESC").all
  end

  def approve
    @store.status = 'online'

    if @store.save
      redirect_to uber_stores_path, notice: "Store is now online."
    else
      head 400
    end
  end

  def decline
    @store.status = 'declined'

    if @store.save
      redirect_to uber_stores_path, notice: "Store is declined."
    else
      head 400
    end
  end

  def toggle_online_status
    if @store.toggle_online_status(:uber)
      redirect_to uber_stores_path, notice: "Store now '#{@store.status}'."
    else
      head 400
    end
  end

private
  def find_store
    @store = Store.find(params[:id])
  end
end
