require 'spec_helper'

describe ProductsController do
  describe 'GET #index' do
    it "index action should render index template" do
      controller.stub(:current_store => FactoryGirl.create(:store))
      get :index
      response.should render_template(:index)
    end

    it "populates an array of messages" do
      
    end
  end
end
