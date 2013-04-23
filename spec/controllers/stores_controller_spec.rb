require 'spec_helper'

describe StoresController do

  let!(:store) {FactoryGirl.build(:store)}

  before (:each) do 
    store.status = "online"
    store.save!
  end
  
  def valid_attributes
    { name: "store_name", 
      description: "store_description",
      path: "store_path" }
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all stores as @stores" do
      get :index, {}, valid_session
      assigns(:stores).should eq([store])
    end
  end

  describe "GET new" do
    it "assigns a new store as @store" do
      get :new, {}, valid_session
      assigns(:new_store).should be_a_new(Store)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Store" do
        expect {
          post :create, {:store => valid_attributes}, valid_session
        }.to change(Store, :count).by(1)
      end

      it "assigns a newly created store as @store" do
        post :create, {:store => valid_attributes}, valid_session
        assigns(:new_store).should be_a(Store)
        assigns(:new_store).should be_persisted
      end

      it "redirects to the created store" do
        post :create, {:store => valid_attributes}, valid_session
        response.should render_template(:confirmation)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved store as @store" do
        Store.any_instance.stub(:save).and_return(false)
        post :create, {:store => { "name" => "invalid value" }}, valid_session
        assigns(:new_store).should be_a_new(Store)
      end

      it "re-renders the 'new' template" do
        Store.any_instance.stub(:save).and_return(false)
        post :create, {:store => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end
end
