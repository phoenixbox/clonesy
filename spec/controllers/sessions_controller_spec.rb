require 'spec_helper'

describe SessionsController do

  describe "GET #new" do
    it "returns http success" do
      get :new
      response.should be_success
    end
  end

  describe "POST #create" do
    context 'with correct credentials' do
      it 'logs in user' do
        user = FactoryGirl.create(:user)
        post :create, sessions: FactoryGirl.attributes_for(:user)
        expect(controller.current_user).to eq user
      end
    end

    context 'with incorrect credentials' do
      it 'does not login the user and redirects the user to login page' do
        user = FactoryGirl.create(:user, email: 'somethingdiff@email.com')
        post :create, sessions: FactoryGirl.attributes_for(:user)
        expect(controller.current_user).to eq false
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "DELETE #destroy" do
    it 'calls logout' do
      controller.should_receive(:logout)
      delete :destroy
    end

    it 'redirects to root url' do
      default_url_options[:host] = 'test.host'
      delete :destroy
      expect(response).to redirect_to(root_url)
    end
  end

end
