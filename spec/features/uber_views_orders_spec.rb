require 'spec_helper'

describe 'Uber views orders' do
  before(:each) do
    @uber = FactoryGirl.create(:user)
    @uber.uber_up
    visit login_path
    fill_in 'sessions_email', with: 'raphael@example.com'
    fill_in 'sessions_password', with: 'password'
    click_button 'Login'
  end

  context "there are existing orders" do
    it 'have a link to each order' do
      @orders = (1..3).map { FactoryGirl.create(:order, user: @uber) }
      visit uber_orders_path
      @orders.each do |order|
        expect(page).to have_xpath("//a[@href='#{uber_order_path(order.id)}']")
      end
    end

    context "within an individual order" do
      before(:each) do
        @store = FactoryGirl.create(:store)
        @user = FactoryGirl.create(:user, email: 'abc@123.com')
        @order = FactoryGirl.create(:order, user: @user, store: @store)
        @product = FactoryGirl.create(:product, store: @store)
        @order_item = FactoryGirl.create(:order_item, order: @order, product: @product)
        visit uber_order_path(@order.id)
      end

      it "displays order creation date and time" do
        expect(page).to have_content(@order.created_at.to_s(:short))
        expect(page).to have_content(@order.updated_at.to_s(:short))
      end

      it "displays purchaser's full name and email address" do
        expect(page).to have_content(@user.email)
      end

      it "displays each product of the order with associated data" do
        expect(page).to have_content(@product.title)
        expect(page).to have_link(@product.title)
        expect(page).to have_xpath("//a[@href='#{store_product_path(@product.store, @product)}']")
        expect(page).to have_content(@order_item.unit_price)
        expect(page).to have_content(@order_item.subtotal)
      end

      it "displays order total" do
        expect(page).to have_content(@order.total)
      end

      it "displays order status" do
        expect(page).to have_content(@order.status)
      end
    end
  end
end
