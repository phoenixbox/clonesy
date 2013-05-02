require 'spec_helper'

describe Uber::AccountController do

  describe "GET#show" do
    context 'when an uber is logged in' do

      before(:each) do
        @user = FactoryGirl.create(:user)
        @user.uber_up
        login_user @user
      end

      it 'assigns the correct uber user' do
        get :show
        assigns(:user).should eq @user
      end

      it 'returns a page with uber users account details' do
        get :show
        response.should render_template(:show)
      end
    end

    context 'when an uber user is NOT logged in' do
      it "redirects them to the home page" do
        get :show
        response.should redirect_to(login_path)
      end
    end
  end

  describe "PUT#update" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @user.uber_up
      login_user @user
    end

    it "locates the requested uber @user" do
      put :update, id: @user, user: FactoryGirl.attributes_for(:user)
      expect(assigns(:user)).to eq(@user)
    end

    context "with valid attributes" do
      it "updates the uber user in the database" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:user, full_name: "S.Rogers")
        @user.reload
        expect(@user.full_name).to eq("S.Rogers")
      end

      it "redirects to the success uber user show page" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:user)
        expect(response).to redirect_to uber_account_path
      end
    end

    context "with invalid attributes" do
      it "does not update the uber user" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:user, full_name: "")
        @user.reload
        expect(@user.full_name).to eq 'Raphael Weiner'
      end

      it "returns the uber user to the uber show page" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:user, full_name: "")
        response.should render_template("show")
      end
    end
  end
end