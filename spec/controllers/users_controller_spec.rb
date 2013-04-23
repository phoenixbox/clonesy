require 'spec_helper'

describe UsersController do
  describe "new" do
    it 'returns the new page' do
      get :new
      response.should be_success
    end
  end

  describe "GET#show" do
    context 'when a user is logged in' do

      before(:each) do
        @user = FactoryGirl.create(:user)
        login_user @user
      end

      it 'assigns the correct user' do
        get :show
        assigns(:user).should eq @user
      end

       it 'returns a page with users account details' do
        get :show
        response.should render_template(:show)
      end
    end

    context 'when a user is NOT logged in' do
      render_views
      it 'redirects them to the home page' do
        get :show
        response.should redirect_to(root_path)
      end
    end
  end

  describe "PUT #update" do

    before :each do
      @user = FactoryGirl.create(:user)
      @user.uber_up
      login_user @user
    end

    it "locates the requested @user" do
      put :update, id: @user, user: FactoryGirl.attributes_for(:user)
      expect(assigns(:user)).to eq(@user)
    end

    context "with valid attributes" do
      it "updates the user in the database" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:user, full_name: "S.Rogers")
        @user.reload
        expect(@user.full_name).to eq("S.Rogers")
      end

      it "redirects to the success user show page" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:user)
        expect(response).to redirect_to profile_path
      end
    end

    context "with invalid attributes" do
      it "does not update the user" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:user, full_name: "")
        @user.reload
        expect(@user.full_name).to eq 'Raphael Weiner'
      end

      it "renders the user show page" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:user, full_name: "")
        response.should render_template("show")
      end
    end
  
  end

end
