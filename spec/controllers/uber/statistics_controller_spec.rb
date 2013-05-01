require 'spec_helper'
  
describe Uber::StatisticsController do
  
  before(:each) do
    controller.stub(:require_uber => true)
  end

  describe 'GET #index' do

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
      
  end

end