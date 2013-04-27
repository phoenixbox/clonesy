require 'spec_helper'

describe Admin::ProductsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @store = FactoryGirl.create(:store)
    @category = FactoryGirl.create(:category, store_id: @store)
    controller.stub(:require_admin => true)
    controller.stub(:current_user => @user)
    controller.stub(:current_store => @store)
    controller.stub(:categories => @category)
  end

  it "index action should render index template" do
    get :index
    expect(response).to render_template(:index)
  end

  it "new action should render new template" do
    get :new
    expect(response).to render_template(:new)
  end

  describe 'GET#index' do
    it 'index action should render the index template' do
      controller.stub(:current_store => FactoryGirl.create(:store))
      get :index
      response.should render_template(:index)
    end
  end

  describe 'POST#create' do

    context "with valid attributes" do
      it "saves the new product to the database" do
        Image.stub(:batch_build).and_return(true)
        params = {title: 'trousers',
                  price: 1.11,
                  store_id: 1,
                  description: 'abc',
                  status: 'active',
                  images: {key: 1}}
        expect { post :create, product: params}.to change(Product, :count).by(1)
      end

      it "redirects to products#index of the current store" do
        post :create, product: {title: 'trousers', price: 1.11, store_id: 1, description: 'abc', status: 'active'}
        expect(response).to redirect_to(store_admin_products_path(@store))
      end
    end

    context "with invalid attributes" do
      it "does not save the new product to the database" do
        expect {
          post :create, product: {title: '', price: 1.11, store_id: 1, description: 'abc', status: 'active'}}.to_not change(Product, :count).by(1)
      end

      it "re-renders products#new view for current store" do
        post :create, product: {title: '', price: 1.11, store_id: 1, description: 'abc', status: 'active'}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT#update' do
    before :each do
      @product = Product.create(title: 'product', price: 1.11, store_id: @store.id, description: 'abc', status: 'active')
    end

    context "with valid attributes" do
      it "changes the product's attributes in the database" do
        put :update, id: @product, product: FactoryGirl.attributes_for(:product, title: "sweater"), store_path: @store.path
        @product.reload
        expect(@product.title).to eq("sweater")
      end

      it "redirects to the products#index of the current store" do
        put :update, id: @product, product: FactoryGirl.attributes_for(:product, title: "sweater"), store_path: @store.path
        @product.reload
        expect(response).to redirect_to(store_admin_products_path(@store))
      end
    end

    context "with invalid attributes" do
      it "does not updates the product in the database" do
        put :update, id: @product, product: FactoryGirl.attributes_for(:product, title: ""), store_path: @store.path
        @product.reload
        expect(@product.title).to_not eq("sweater")
      end

      it "re-renders products#edit view for the current store" do
        put :update, id: @product, product: FactoryGirl.attributes_for(:product, title: ""), store_path: @store.path
        @product.reload
        expect(response).to render_template("edit")
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @product = Product.create(title: 'product', price: 1.11, store_id: @store.id, description: 'abc', status: 'active')
    end

    it "deletes the product" do
      expect {delete :destroy, id: @product}.to change(Product, :count).by(-1)
    end

    it "redirects to the products#index of the current store" do
      delete :destroy, id: @product
      expect(response).to redirect_to(store_admin_products_path(@store))
    end
  end

  describe 'POST#toggle_status' do
    before :each do
      @product = Product.create(title: 'product', price: 1.11, store_id: @store.id, description: 'abc', status: 'active')
    end

    it "toggles the product status" do
      put :toggle_status, id: @product, product: {status: 'retired'}
      @product.reload
      expect(@product.status).to eq 'retired'
    end
  end

  describe 'DELETE#destroy_image' do
    before :each do
      @product = Product.create(title: 'product', price: 1.11, store_id: @store.id, description: 'abc', status: 'active')
      @image = @product.images.create(data: File.new(Rails.root + 'spec/support/test_image.png'))
    end

    it "deletes the correct image" do
      delete :destroy_image, id: @product, image_id: @image.id
      expect { @product.reload }.to change { @product.images.length }.to(0).from(1)
    end
  end
end
