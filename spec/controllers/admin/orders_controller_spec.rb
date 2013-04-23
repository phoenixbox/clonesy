require 'spec_helper'

describe Admin::OrdersController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @store = FactoryGirl.create(:store)
    controller.stub(:require_admin => true)
    controller.stub(:current_user => @user)
    controller.stub(:current_store => @store)
  end

  it "index action should render index template" do

    get :index
    response.should render_template(:index)
  end

  it "index action should return a collection of orders" do
    orders = [ FactoryGirl.create(:order, user: @user, store: @store) ]

    get :index
    expect(assigns(:orders)).to match_array orders
  end

  it "show action should return an individual order" do
    order = FactoryGirl.create(:order, user: @user, store: @store)

    get :show, id: order.id
    expect(assigns(:order)).to eq order
  end

  describe 'update' do
    it 'works correctly' do
      order = FactoryGirl.create(:order, user: @user, store: @store)
      request.env["HTTP_REFERER"] = '/'
      put :update, id: order.id, update_status: true
      order.reload
      expect(order.status).to eq 'cancelled'
    end
  end
end
