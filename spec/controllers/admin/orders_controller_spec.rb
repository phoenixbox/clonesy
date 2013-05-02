require 'spec_helper'

describe Admin::OrdersController do
  let(:product) { FactoryGirl.create(:product, store: @store) }

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
    order = FactoryGirl.create(:order, user: @user)
    order.order_items.create(product_id: product.id, quantity: 1, unit_price: 1)

    get :index
    expect(assigns(:admin_order_view).orders).to match_array [order]
  end

  it "show action should return an individual order" do
    order = FactoryGirl.create(:order, user: @user)

    get :show, id: order.id
    expect(assigns(:order)).to eq order
  end
end
