class StoresController < ApplicationController
  def new
    @new_store = Store.new
  end

  def create
    @new_store = Store.new(params[:store])

    if @new_store.save
      Role.promote(current_user, @new_store, 'admin')
      render :confirmation
    else
      render :new
    end
  end
end
