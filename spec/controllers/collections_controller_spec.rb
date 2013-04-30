require 'spec_helper'

describe CollectionsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @collection = FactoryGirl.create(:collection, user: @user)
    @valid_attributes = { collection: { name: "bicycles" } }
    @invalid_attributes = { collection: { name: "" } }
    controller.stub(current_user: @user)
  end

  describe "POST #create" do
    it "increases the collection by 1 with valid attributes" do
      expect { post :create, @valid_attributes}.
        to change(Collection, :count).by(1)
    end

    it "does not create the collection with invalid attributes" do
      expect { post :create, @invalid_attributes }.
        to_not change(Collection, :count)
    end
  end

  describe "GET #show" do
    before(:each) do
      get :show, id: @collection
    end

    it "displays the collection" do
      response.should render_template(:show)
    end

    it "assigns requested collection as @collection" do
      expect(assigns(:collection)).to eq (@collection)
    end
  end

  describe "PUT #update" do
    it "updates the specified collection with valid attributes" do
      put :update, id: @collection, collection: { name: "a_new_name" }
      expect(Collection.first.name).to eq "a_new_name"
    end

    it "doesnt update the specified collection with invalid attributes" do
      put :update, id: @collection
      expect(Collection.first.name).to_not eq "a_new_name"
    end
  end

  describe "GET #index" do
    before(:each) do
      FactoryGirl.create(:collection, user: @user)
      FactoryGirl.create(:collection, user: FactoryGirl.build(:user))
    end

    it "renders an index of all user's collections" do
      get :index
      expect(assigns(:collections).count).to eq 2
    end
  end

  describe "DELETE #destroy" do
    it "deletes the collection from the database" do
      expect { delete :destroy, id: @collection }.
        to change(Collection, :count).by(-1)
    end
  end

  describe "POST #add_product" do
    let!(:store) { FactoryGirl.create(:store) }
    let!(:product) { FactoryGirl.create(:product, store_id: store.id ) }

    before(:each) do
      @request.env['HTTP_REFERER'] = 'http://localhost:3000/'
    end

    it "adds a product to the user's collection" do
      post :add_product, id: @collection, product_id: product.id
      expect(@collection.products).to include(product)
    end
  end

  describe "DELETE #remove_product" do
    let!(:store) { FactoryGirl.create(:store) }
    let!(:product) { FactoryGirl.create(:product, store_id: store.id ) }

    before(:each) do
      @collection.add_product(product)
      @request.env['HTTP_REFERER'] = 'http://localhost:3000/'
    end

    it "removes the product from the collection" do
      delete :remove_product, id: @collection, product_id: product.id
      @collection.reload
      expect(@collection.products).to_not include(product)
    end
  end
end
