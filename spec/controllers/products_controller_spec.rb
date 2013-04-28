require 'spec_helper'

describe ProductsController do
  describe 'GET #index' do
    it "index action should render index template" do
      store = FactoryGirl.create(:store)

      controller.stub(current_store: store)
      store.should_receive(:increase_popularity).and_return(true)

      get :index
      response.should render_template(:index)
    end
  end

  describe 'GET #show'do
   it "show action should render the show template" do
      store = FactoryGirl.create(:store)
      product = FactoryGirl.create(:product, store: store)

      controller.stub(current_store: store)
      LocalStore.should_receive(:increase_popularity).and_return(true)

      get :show, id: product
      response.should render_template(:show)
    end
  end
end
