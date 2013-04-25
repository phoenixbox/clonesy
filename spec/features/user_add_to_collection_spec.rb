require 'spec_helper'

describe "user adds product to collection" do

  let!(:user){ FactoryGirl.create(:user) }
  let(:store){ FactoryGirl.create(:store) }
  let(:product){ FactoryGirl.create(:product, store_id: store.id) }

  before(:each) do
    visit '/login'
    fill_in 'sessions_email', with: 'raphael@example.com'
    fill_in 'sessions_password', with: 'password'
    click_button 'Login'
  end

  context "given a user is logged in" do

    context "given a user has already made a collection" do

      before do
      end

      it "adds the product to the users chosen collection" do
        pending
        collection = Collection.new(name: "first_collection", user_id: user.id) 
        visit product_path(product)
        collection_link = find_field('Add to Collection').find('option[collection.name]') 
        expect(collection_link).to be
      end

      it "re-renders the product#show page"
      end
    end

    context "given a user has not already made a collection" do

      it "has an option to create a new collection"
      it "when clicked 'create collection' redirects to collection#new page"

    end


  context "given a user is not logged in" do

    it "when clicked 'create collection' redirects to session#new"

  end
end