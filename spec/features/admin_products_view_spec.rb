require 'spec_helper'

describe 'the admin products view', type: :feature do
  before(:each) do
    admin = FactoryGirl.create(:user)
    @store = FactoryGirl.create(:store)
    Role.promote(admin, @store, 'admin')
    visit login_path
    fill_in 'sessions_email', with: 'raphael@example.com'
    fill_in 'sessions_password', with: 'password'
    click_button 'Login'
    visit store_admin_products_path(@store)
  end

  it 'should have a title' do
    expect(page).to have_selector('h1', text: 'Products')
  end

  it 'should have a create product button' do
    expect(page).to have_button('New Product')
  end

  it 'creates a new product with valid input' do
    click_button 'New Product'
    fill_in "Title", with: 'something'
    fill_in "Description", with: 'blah blah blah'
    fill_in "Price", with: '1.99'
    choose('active')
    click_button "Submit"
    expect(current_path).to eq store_admin_products_path(@store)
  end

  it 'fails to create a new product with invalid input' do
    click_button 'New Product'
    fill_in "Description", with: 'blah blah blah'
    fill_in "Price", with: '1.99'
    choose('active')
    click_button "Submit"
    expect(page).to have_content("can't be blank")
  end

  it 'edits a product correctly' do
    product = FactoryGirl.create(:product, store: @store)
    visit edit_store_admin_product_path(@store, product)
    fill_in "Title", with: "whateveryouwant"
    click_button "Submit"
    expect(current_path).to eq store_admin_products_path(@store)
  end

  it 'edits a product with incorrect info' do
    product = FactoryGirl.create(:product, store: @store)
    visit edit_store_admin_product_path(@store, product)
    fill_in "Title", with: ""
    click_button "Submit"
    expect(page).to have_content("can't be blank")
  end

  it 'can destroy an existing product' do
    product = FactoryGirl.create(:product, store: @store)
    page.driver.submit :delete, store_admin_product_path(@store, product), {}
    expect(Product.all).to eq []
  end

  it 'can retire an active product' do
    product = FactoryGirl.create(:product, store: @store)
    page.driver.put toggle_status_store_admin_product_path(@store, product)
    expect(product.reload.status).to eq 'retired'
  end

  it 'can activate a retired product' do
    product = FactoryGirl.create(:product, status: 'retired', store: @store)
    page.driver.put toggle_status_store_admin_product_path(@store, product)
    expect(product.reload.status).to eq 'active'
  end
end

