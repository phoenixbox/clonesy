require 'spec_helper'

describe 'uber statistics view', type: :feature do

  before(:each) do
    @admin = FactoryGirl.create(:user)
    @store = FactoryGirl.create(:store)
    Role.promote(@admin, @store, 'admin')
    @admin.uber_up
    visit login_path
    fill_in 'sessions_email', with: 'raphael@example.com'
    fill_in 'sessions_password', with: 'password'
    click_button 'Login'
    visit uber_statistics_path
  end

  context "when viewing the statistics page" do
    
    it "the page path is the uber/dashboard#index" do
      expect(current_path).to eq uber_statistics_path
    end

  end

end