require 'spec_helper'

describe CollectionsController do 

  let!(:user){ FactoryGirl.create(:user) }
  let!(:collection) { FactoryGirl.create(:collection, user_id: user.id) }

  describe "POST #create" do 

     
    def valid_attributes 
      { 
        collection: {
        name: "bicycles", 
        theme: "outdoors",
        user_id: user.id
        }
      }
    end

    def invalid_attributes
      { user_id: user.id}
    end
       
    it "increases the collection by 1 with valid attributes" do    
      expect { 
        post :create, valid_attributes}.to change(Collection, :count).by(1)
    end

    it "does not create the collection with invalid attributes" do 
      expect{
        post :create, invalid_attributes }.to_not change(Collection, :count).by(1)
    end
  end 

  describe "GET #show" do 
    
    before(:each) do
      get :show, id: collection
    end

    it "displays the collection" do
      response.should render_template(:show)
    end

    it "assigns requested collection as @collection" do
      expect(assigns(:collection)).to eq (collection)
    end

  end

  describe "PUT #update" do 

    it "updates the specified collection with valid attributes" do 
      put :update, id: collection, collection: { name: "a_new_name" }
      expect(Collection.first.name).to eq "a_new_name"
    end

    it "doesnt update the specified collection with invalid attributes" do
      put :update, id: collection
      expect(Collection.first.name).to_not eq "a_new_name"
    end
  end 

  describe "GET #index" do 
  end

  describe "DELETE #destroy" do 

    it "deletes the collection from the database" do
      expect {
        delete :destroy, id: collection}.to change(Collection, :count).by(-1)
    end

  end

  describe "POST #add_product" do 
  end
end 