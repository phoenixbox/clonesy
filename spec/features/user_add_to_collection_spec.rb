require 'spec_helper'

describe "user adds product to collection" do
  let!(:user){ FactoryGirl.create(:user) }
  let!(:store){ FactoryGirl.create(:store) }
  let(:product){ FactoryGirl.create(:product, store_id: store.id) }

  before do
    LocalStore.stub(:increase_popularity).and_return(true)
    FactoryGirl.create(:collection, name: "favorites", user: user)
    visit '/login'
    fill_in 'sessions_email', with: 'raphael@example.com'
    fill_in 'sessions_password', with: 'password'
    click_button 'Login'
  end

  context "given a user is logged in" do
    context "given a user has not already made a collection" do
      it "has an option to create a new collection" do
        visit store_product_path(store, product)
        within(:css, 'ul.dropdown-menu'){
          expect(page).to have_css('a#create-new')
        }
      end

      it "when clicked 'create collection' redirects to collections#NEW page" do
        visit store_product_path(store, product)
        within(:css, 'ul.dropdown-menu'){
          click_link 'Create New Collection'
        }
        expect(current_path).to eq new_account_collection_path
      end

      it "allows the user to create a new collection" do
        visit new_account_collection_path
        fill_in "collection_name", with: "Hats"
        click_button 'Submit'
        expect(page).to have_content("Hats")
        expect(current_path).to eq account_collection_path(Collection.last)
      end
    end

    context "given a user has already made a collection" do
      let!(:collection) { FactoryGirl.create(:collection, user_id: user.id) }

      before do
        visit '/login'
        fill_in 'sessions_email', with: 'raphael@example.com'
        fill_in 'sessions_password', with: 'password'
        click_button 'Login'
      end

      it "adds the product to the users chosen collection" do
        visit store_product_path(store, product)
        click_link collection.name
        expect(page).to have_content "Product added to the #{collection.name} collection"
      end

      it "can only add a product once to a collection" do
        2.times do
          visit store_product_path(store, product)
          click_link collection.name
        end
        expect(collection.products.count).to eq 1
      end

      it "re-renders the product#show page" do
        visit store_product_path(store, product)
        click_link collection.name
        expect(current_path).to eq store_product_path(store, product)
      end
    end
  end
end
