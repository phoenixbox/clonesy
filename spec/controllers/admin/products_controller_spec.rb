require 'spec_helper'

describe Admin::ProductsController do
  fixtures :all
  render_views

  it "index action should render index template" do
    user = FactoryGirl.create(:uber)
    store = Store.create(name: 'he', path: 'ha')
    controller.stub(:require_admin => true)
    controller.stub(:current_user => user)
    controller.stub(:current_store => store)
    get :index
    response.should render_template(:index)
  end

  it "new action should render new template" do
    controller.stub(:require_admin => true)
    get :new
    response.should render_template(:new)
  end
end
