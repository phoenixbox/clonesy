require 'spec_helper'

describe Admin::DashboardsController do
  before (:each) do
    @store = FactoryGirl.create(:store)
    @admin = FactoryGirl.create(:user)
    controller.stub(:require_admin => true)
    controller.stub(:current_user => @admin)
    controller.stub(:current_store => @store)
  end

  describe "admin is logged in" do
    context "and visits manage" do
      it "manage action should render manage template" do
        get :manage
        response.should render_template(:manage)
      end
    end

    context "and visits edit / update" do
      it "edit action should render edit template" do
        get :edit, store_path: @store.path
        response.should render_template(:edit)
      end

      it "can update the store's title" do
        pending
        put :update,  store_path: @store.path,
                      store: FactoryGirl.attributes_for(:store, title: "New Store")
        @store.reload
        expect(@store.title).to eq 'New Store'
      end
    end
  end
end