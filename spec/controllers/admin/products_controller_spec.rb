require 'spec_helper'

describe Admin::ProductsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @store = FactoryGirl.create(:store)
    controller.stub(:require_admin_or_stocker => true)
    controller.stub(:current_user => @user)
    controller.stub(:current_store => @store)
  end

  it "index action should render index template" do
    get :index
    expect(response).to render_template(:index)
  end

  it "new action should render new template" do
    get :new
    expect(response).to render_template(:new)
  end
end
