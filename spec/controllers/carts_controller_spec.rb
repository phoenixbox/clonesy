require 'spec_helper'

describe CartsController do
  let!(:store){FactoryGirl.create(:store)}
  let!(:p){FactoryGirl.create(:product, store: store)}

  before(:each) do
    @cart = Cart.new({})
    controller.stub(:current_cart => @cart)
    request.env["HTTP_REFERER"] = '/'
  end

  describe "Carts#Update" do
    it "updates the cart details" do
      expect(@cart.count).to eq nil
      put :update, carts: {product_id: p.id, quantity: '10'}
      expect(@cart.count).to eq "(10)"
    end

    it "does not update the cart details with invalid quantity" do
      put :update, carts: {product_id: p.id, quantity: '5'}
      expect(@cart.count).to eq "(5)"
      put :update, carts: {product_id: p.id, quantity: '-10'}
      expect(@cart.count).to eq "(5)"
    end
  end

  describe "Carts#Remove_Item" do
    it "removes the item from the cart" do
      put :update, carts: {product_id: p.id, quantity: '10'}
      expect(@cart.empty?).to eq false
      put :remove_item, product_id: p.id, store_path: store.path
      expect(@cart.empty?).to eq true
    end
  end

  describe "Carts#Destroy" do
    it "removes all items from cart" do
      put :update, carts: {product_id: p.id, quantity: '10'}
      expect(@cart.empty?).to eq false
      delete :destroy, store_path: store.path
      expect(@cart.empty?).to eq true
    end
  end

end

