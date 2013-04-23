require 'spec_helper'

describe Admin::OrderItemsController do
  before (:each) do
    @store = FactoryGirl.create(:store)
    @admin = FactoryGirl.create(:user)
    controller.stub(:require_admin => true)
    controller.stub(:current_user => @admin)
    controller.stub(:current_store => @store)
  end

  describe "admin is logged in" do
    before(:each) do
      @product = FactoryGirl.create(:product, store: @store)
      @order = FactoryGirl.create(:order, store: @store, user: @admin)
      @order_item = FactoryGirl.create(:order_item, order: @order, product: @product)
    end

    context "and changes the quantity of an order item" do
      it "should update" do
        request.env["HTTP_REFERER"] = '/'
        put :update,  store_path: @store.path,
                      admin_order_item: { quantity: 5, order_item_id: @order_item.id }
        @order_item.reload
        expect(@order_item.quantity).to eq 5
      end
    end

    context "can destroy the order item" do
      it "should destroy" do
        request.env["HTTP_REFERER"] = '/'
        delete :destroy, id: @order_item.id, store_path: @store.path
        # expect(@order_item.id).to eq nil
      end
    end
  end
end