require 'spec_helper'

describe 'user account detail view' do
  context 'when the user is logged in' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      visit '/login'
      fill_in 'sessions_email', with: 'raphael@example.com'
      fill_in 'sessions_password', with: 'password'
      click_button 'Login'
    end

    it 'displays the main page of their account details' do
      visit 'profile'
      expect(page).to have_content("Account")
    end

    it 'cannot update their profile with incorrect information' do
      visit 'profile'
      fill_in 'Full Name', with: ''
      click_button 'Submit'
      expect(page).to have_content("can't be blank")
    end

    context 'when they click the link to create a store' do
      it 'takes them to the create a new store page' do
        visit 'profile'
        click_link "Create New Store"
        expect(page).to have_content("New Store")
      end
    end

    context 'when they fill in the new store creation form' do
      it "can create a new store with valid information" do
        visit new_store_path
        fill_in 'store_name', with: "jewellery"
        fill_in 'store_path', with: "jewellery"
        fill_in 'store_description', with: "the finest jewellery"
        click_button "Create Store"
        expect(page).to have_content("Your store is pending approval")
      end

      it "cannot create a new store with invalid information" do
        visit new_store_path
        click_button "Create Store"
        expect(page).to have_content("can't be blank")
      end
    end

    context 'when they click the link to edit their account details' do
      it "should take them to their account details edit page" do
        visit profile_path
        click_link "Edit"
        expect(page).to have_content("Edit")
      end
    end

    context 'when they click the link to their order history page' do
      it 'takes them to their order history page' do
        visit 'profile'
        click_link "Order History"
        expect(page).to have_content("Order History")
      end
    end

    context 'when they click the link to go to their collections index' do
      it "takes them to their collections index page" do
        visit 'profile'
        click_link 'Collections'
        expect(current_path).to eq account_collections_path
      end

      context "when they are viewing their collections index" do

        it "they can create new collection with valid information" do
          visit new_account_collection_path
          fill_in 'collection_name', with: 'Bicycles'
          fill_in 'collection_theme', with: 'outdoors'
          click_button "Submit"
          expect(page).to have_content("Bicycles")
        end

        xit "cannot create a new store with invalid information" do
          visit account_collection_path
          fill_in 'collection_name', with: ''
          fill_in 'collection_them', with: 'outdoors'
          click_button "Create Collection"
          expect(page).to have_content("can't be blank")
        end

      end

    end

    context 'when they click on a specific order link' do
      it 'takes them to a view of their specific order' do
        order = FactoryGirl.create(:order, user: @user)
        visit 'account/orders'
        click_link "Order ##{order.id}"
        expect(page).to have_content("Quantity")
      end
    end
  end
end
