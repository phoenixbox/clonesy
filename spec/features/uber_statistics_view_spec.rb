require 'spec_helper'

describe 'the uber statistics view', type: :feature do

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

  it "should be on the uber stats index page" do
    expect(current_path).to eq uber_statistics_path
  end

  it 'should have a title' do
    expect(page).to have_selector('h1', text: 'Statistics')
  end

  it "should have an order value title" do
    expect(page).to have_selector('h3', text: 'Order Value Over Time')
  end  

  it "should have an Average Spend per Customer title" do
    expect(page).to have_selector('h3', text: 'Average Spend per Customer')
  end

  it "should have to have a Top 5 Bestsellers title" do
    expect(page).to have_selector('h3', text: 'Top 5 Bestsellers')
  end

end