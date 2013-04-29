require 'spec_helper'

describe CheckoutsController do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_shipping) { FactoryGirl.create(:shipping_address) }
  let!(:user_billing) { FactoryGirl.create(:billing_address) }
  let(:store) { FactoryGirl.create(:store) }
  let!(:product) { FactoryGirl.create(:product, store: store) }
  let(:cart_contents) { { product.id => 1 } }
  let!(:cart) { SessionCart.new(cart_contents) }

  describe "an unauthenticated user checks out" do
    let(:valid_attributes) { { user: {
                                email: "email@thisemail.com",
                                shipping_address_attributes: {
                                  street: '43 Logan Street',
                                  state: 'CA',
                                  zipcode: '90100',
                                  city: 'The Angels'},
                                billing_address_attributes: {
                                  street: '43 Logan Street',
                                  state: 'CA',
                                  zipcode: '90100',
                                  city: 'The Angels'
                                  } } } }

    let(:invalid_attributes) { { user: { email: "email@thisemail.com" } } }

    context "the user enters correct information" do
      before do
        ApplicationController.any_instance.stub(:current_cart).and_return(cart)
        controller.stub(:send_order_email)
      end

      it "allows that user to place an order" do
        post :create, valid_attributes
        expect(Order.count).to eq 1
      end
    end

    context "the user enters incorrect information" do
      it "does not allow that user to place an order" do
        post :create, invalid_attributes
        expect(Order.count).to eq 0
      end
    end
  end

  describe "an authenticated user checks out" do
    before (:each) do
      login_user(user)
    end

    context "the user enters correct information" do
      before (:each) do
        user.shipping_address = user_shipping
        user.billing_address = user_billing
        user.save!

        controller.stub(:send_order_email)
      end

      it "allows that user to place an order" do
        ApplicationController.any_instance.stub(:current_cart).and_return(cart)

        post :create
        expect(Order.count).to eq 1
      end
    end

    context "the user enters incorrect information" do
      it "does not allow that user to place an order" do
        post :create
        expect(Order.count).to eq 0
      end
    end
  end

  describe "an unauthenticated user clicks 'buy now'" do
    it "directs the user to the sign up page" do
      post :buy_now, { product_id: product.id }
      expect(page).to redirect_to(login_path)
    end
  end

  describe "an authenticated user clicks 'buy now" do
    before do
      ApplicationController.any_instance.stub(:current_user).and_return(user)
      controller.stub(:send_order_email)
    end

    it "allows that user to check out" do
      post :buy_now, { product_id: product.id }
      expect(Order.count).to eq 1
    end
  end
end
