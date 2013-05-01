require 'spec_helper'

describe Admin::StatisticsController do
  
  before(:each) do
    @store = FactoryGirl.create(:store)
    @admin = FactoryGirl.create(:user)
    controller.stub(:require_admin => true)
    controller.stub(:current_user => @admin)
    controller.stub(:current_store => @store)
  end

  describe "admin is logged in" do
    it 'and visits the statistics index page' do
      get :index
      response.should render_template(:index)
    end
  end

end