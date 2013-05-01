require 'spec_helper'


describe "user favorites" do 

  let(:store) { FactoryGirl.create(:store) }
  let(:product) { FactoryGirl.create(:product, store: store) }
  let(:user) { FactoryGirl.create(:user) }

  context "authenticated user adds product to favorites" do 
    before do 
      LocalStore.stub(:increase_popularity).and_return(true)
      visit '/login'
      fill_in 'sessions_email', with: 'raphael@example.com'
      fill_in 'sessions_password', with: 'password'
      click_button 'Login'
      visit store_product_path(store, product)
    end

    it "has a link to add to favorites" do 
      pending
      expect(page).to have_content("Add to Favorites")
    end

    it "adds the product to the user's favorites" do 
      pending
      click_on "Add to Favorites"
      expect(user.favorites).to include(product)
    end
  end

  context "unauthenticated user adds product to favorites" do 

    it "asks the user to first log in" do 
      pending
      expect(page).to have_content("Please first log in to add product to favorites.")
    end
  end
end 