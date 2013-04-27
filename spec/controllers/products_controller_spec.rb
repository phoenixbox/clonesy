require 'spec_helper'

describe ProductsController do
  
  describe 'GET #index' do
    it "index action should render index template" do
      controller.stub(:current_store => FactoryGirl.create(:store))
      get :index 
      response.should render_template(:index)
    end
  end

  describe 'GET #show'do
   it "show action should render the show template" do
      current_store = FactoryGirl.create(:store)
      controller.stub(:current_store) { current_store }
      product = FactoryGirl.create(:product, store: current_store)
      get :show, id: product
      response.should render_template(:show)
    end
  end
end
