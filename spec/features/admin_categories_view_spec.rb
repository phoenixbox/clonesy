require 'spec_helper'

describe 'the admin categories view', type: :feature do
  before(:each) do
    admin = FactoryGirl.create(:user)
    @store = FactoryGirl.create(:store)
    FactoryGirl.create(:collection, name: 'favorites', user: admin)
    Role.promote(admin, @store, 'admin')
    visit login_path
    fill_in 'sessions_email', with: 'raphael@example.com'
    fill_in 'sessions_password', with: 'password'
    click_button 'Login'
    visit store_admin_categories_path(@store)
  end

  it 'should have a title' do
    expect(page).to have_selector('h1', text: 'Categories')
  end

  it 'should have a create category button' do
     expect(page).to have_button('New Category')
  end

  context 'when a category exists' do
    before(:each) do
      click_button "New Category"
      fill_in 'Title', with: 'mah things'
      click_button "Submit"
    end

    it 'creates a new category with valid input' do
      expect(current_path).to eq store_admin_categories_path(@store)
    end

    it 'rejects invalid category input' do
      click_button "New Category"
      fill_in 'Title', with: 'mah things'
      click_button "Submit"
      expect(page).to have_content "has already been taken"
    end

    it 'edits a category with valid input' do
      click_link "Edit"
      fill_in "Title", with: 'gooey'
      click_button "Submit"
      expect(current_path).to eq store_admin_categories_path(@store)
    end
  end
end
