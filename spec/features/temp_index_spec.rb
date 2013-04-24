require 'spec_helper'

describe 'Index page spec' do
  before(:each) { visit root_path }

  describe 'landing on index page' do
    context 'as an anonymous shopper' do
      it 'has link to login' do
        click_link 'Login'
        expect(current_path).to eq login_path
      end

      it 'has a link to sign up' do
        click_link 'Sign Up'
        expect(current_path).to eq signup_path
      end

      # TODO: waiting on cart image
      it 'has a link to the cart' do
        click_link 'cart'
        expect(current_path).to eq root_path
      end

      it 'has a search bar input with no contents' do
        expect(find_field('search-query').value).to eq nil
      end

      xit 'has four featured products' do
      end
    end

    context 'as a registered shopper' do
      before(:each) {
        @user = FactoryGirl.create(:user)
        visit login_path
        fill_in 'sessions_email', :with => "raphael@example.com"
        fill_in 'sessions_password', :with => "password"
        click_button "Login"
      }

      it 'has a link to my account page as my first name' do
        expect(page).to have_content(@user.full_name.split(' ').first)
      end
    end
  end


  describe 'searching' do
  end
end
