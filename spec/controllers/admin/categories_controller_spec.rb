require 'spec_helper'

describe Admin::CategoriesController do
  before (:each) do
    @store = FactoryGirl.create(:store)
    @category = FactoryGirl.create(:category)
    @admin = FactoryGirl.create(:user)
    controller.stub(:require_admin => true)
    controller.stub(:current_user => @user)
  end

  context "" do

  end
end
