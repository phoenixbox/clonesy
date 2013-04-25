require 'spec_helper'

describe CollectionsController do 

  let!(:user){ FactoryGirl.create(:user) }

  describe "POST #create" do 

    before (:each) do 
      valid_attributes = {
        name: "a_new_collection", 
        user_id: user.id
        } 
    end  

   it "increases the collection by 1" do    
      expect { 
        post :create, valid_attributes}.to change(Collection, :count).by(1)
    end
  end 

  describe "GET #show" do 
  end

  describe "PUT #update" do 
  end 

  describe "GET #index" do 
  end

  describe "DELETE #destroy" do 
  end

  describe "POST #add_product" do 
  end
end 