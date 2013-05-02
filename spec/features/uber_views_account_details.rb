require 'spec_helper'

describe 'uber account#show page' do
  
  context 'when the uber user is logged in' do
    
    before(:each)do
      @user = FactoryGirl.create(:user)
      @user.uber_up
      visit '/login'
      fill_in 'sessions_email', with: 'raphael@example.com'
      fill_in 'sessions_password', with: 'password'
      click_button 'Login'
    end

    context "viewing their account detail page" do

      it "displays their account detail page" do
        visit 'uber/account'
        expect(page).to have_content("Edit Account Details")
      end

      it "updates the uber profile with correct information" do
        visit 'uber/account'
        fill_in "Full Name", with: "S.Rogers"
        click_button "Submit"
        expect(page).to have_content('Successfully updated uber account')
      end

      it "cannot update the uber profile with incorrect information" do
        visit 'uber/account'
        fill_in "Full Name", with: ''
        click_button 'Submit'
        expect(page).to have_content("can't be blank")
      end

    end

  context "click link to view stores management page" do

    it "takes them to the store mgmt page" do
      visit 'uber/account'
      click_link "Stores Management"
      expect(current_path).to eq uber_stores_path
    end
  end
end