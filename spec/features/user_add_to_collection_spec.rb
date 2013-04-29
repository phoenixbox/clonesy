require 'spec_helper'

describe "user adds product to collection" do

  let!(:user){ FactoryGirl.create(:user) }
  let(:store){ FactoryGirl.create(:store) }
  let(:product){ FactoryGirl.create(:product, store_id: store.id) }

  before do
    visit '/login'
    fill_in 'sessions_email', with: 'raphael@example.com'
    fill_in 'sessions_password', with: 'password'
    click_button 'Login'
  end

  context "given a user is logged in" do

    context "given a user has not already made a collection" do

      it "has an option to create a new collection" do
        visit store_product_path(store, product)
        within(:css, 'ul#collection-list'){
          expect(page).to have_css('a#create-new')
        }
      end

      it "when clicked 'create collection' redirects to collection#INDEX page" do
        visit store_product_path(store, product)
        within(:css, 'ul#collection-list'){
          click_link 'Create New Collection'
        }
        expect(current_path).to eq new_account_collection_path
      end

      it "allows the user to create a new collection" do 
        visit new_account_collection_path
        fill_in "collection_name", with: "Hats"
        fill_in "collection_theme", with: "Awesome Ones"
        click_button 'Submit'
        expect(current_path).to eq account_collections_path
        expect(page).to have_content("Hats")
      end
    end

    context "given a user has already made a collection" do

      let!(:collection) { FactoryGirl.create(:collection, user_id: user.id) }

      before do
        visit '/login'
        fill_in 'sessions_email', with: 'raphael@example.com'
        fill_in 'sessions_password', with: 'password'
        click_button 'Login'
        collection.products << product
      end

      xit "adds the product to the users chosen collection" do
        visit store_product_path(store, product)
        click_on "account/collections/#{collection.id}"
        collections.reload
        expect(collection.products).to include(product)
      end

      it "re-renders the product#show page"
      end
    end



  context "given a user is not logged in" do

    it "when clicked 'create collection' redirects to session#new"

  end
end