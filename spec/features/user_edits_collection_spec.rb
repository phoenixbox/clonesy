require 'spec_helper'

describe "user edits collection" do
  let!(:user){ FactoryGirl.create(:user) }
  let!(:collection) { user.collections.create(name: 'Shoes Shoes') }

  before do
    FactoryGirl.create(:collection, name: 'favorites', user: user)
    LocalStore.stub(:increase_popularity).and_return(true)
    visit '/login'
    fill_in 'sessions_email', with: 'raphael@example.com'
    fill_in 'sessions_password', with: 'password'
    click_button 'Login'
  end

  context "given a user is logged in and has a collection" do
    it "they can edit the collection" do
      visit account_collection_path(collection)
      click_link 'edit-collection'
      fill_in 'collection_name', with: 'Hats and Hats'
      click_button 'Update'
      collection.reload
      expect(collection.name).to eq 'Hats and Hats'
      expect(current_path).to eq account_collection_path(collection)
    end

    it "they can delete a collection" do
      visit account_collection_path(collection)
      expect { click_link_or_button 'delete-collection' }.
        to change { user.collections.count }.by -1
    end

    it "they can remove items from a collection" do
      store = FactoryGirl.create(:store)
      collection.products.create!(title: 'a', description: 'b', status: 'active', price: 1, store_id: store.id)
      visit account_collection_path(collection)
      expect { click_link 'Remove' }.to change {collection.products.count }.by -1
    end
  end
end
