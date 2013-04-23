require 'spec_helper'

describe Admin::CategoriesController do
  before (:each) do
    @store = FactoryGirl.create(:store)
    @admin = FactoryGirl.create(:user)
    controller.stub(:require_admin => true)
    controller.stub(:current_user => @admin)
    controller.stub(:current_store => @store)
  end

  describe "admin is logged in" do
    context "and visits the index" do
      it "index action should render index template" do
        get :index
        response.should render_template(:index)
      end

      it "index action should return a collection of orders" do
        categories = [ FactoryGirl.create(:category, store_id: @store.id) ]
        get :index
        expect(assigns(:categories)).to match_array categories
      end
    end

    context "and visits new" do
      it "new action should render new template" do
        get :new
        response.should render_template(:new)
      end

      it "can create a new category" do
        post :create, title: "New Category"
      end
    end

    context "and visits edit" do
      let!(:c){FactoryGirl.create(:category, store_id: @store.id)}

      it "edit action shoudl render edit template" do
        get :edit, id: c.id
        response.should render_template(:edit)
      end

      it "can update the category" do
        put :update,  id: c.id, store_path: @store.path,
                      category: FactoryGirl.attributes_for(:category, title: "New Title")
        c.reload
        expect(c.title).to eq 'New Title'
      end
    end
  end
end
