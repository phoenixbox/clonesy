class Admin::StatisticsController < ApplicationController

  before_filter :require_admin

  def index
    @orders = OrderItem.all
  end


end
