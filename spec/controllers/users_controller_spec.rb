require 'spec_helper'

describe UsersController do
  describe "new" do
    it 'returns the new page' do
      get :new
      response.should be_success
    end
  end

  describe "POST#create" do
    
    let(:valid_attributes) do {
      user: {full_name: "John Smith", email: "example@example.com", password: "password", password_confirmation: "password"} }
    end
    let(:invalid_attributes) do {
      user: {full_name: "", email: "example@example.com", password: "", password_confirmation: "password"} }
    end

    context "with valid attributes" do
      it "saves the new user in the database" do
        controller.stub(:enqueue_welcome_email)
        expect {
          post :create, valid_attributes}.to change(User, :count).by(1)
      end

      it "redirects to the home page" do
        controller.stub(:enqueue_welcome_email)
        post :create, valid_attributes
        response.should redirect_to(root_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new user in the database" do
        controller.stub(:enqueue_welcome_email)
        expect {
          post :create, invalid_attributes}.to_not change(User, :count).by(1)
      end

      it "renders the new user page" do
        controller.stub(:enqueue_welcome_email)
        post :create, invalid_attributes
        response.should render_template("new")
      end
    end

    context "user exists and is an orphan" do
      it "updates the orphan attribute to false" do
        controller.stub(:enqueue_welcome_email)
        @user = FactoryGirl.create(:user, orphan: true)
        post :create, user: {email: 'raphael@example.com'}
        @user.reload
        expect(@user.orphan).to be false
      end
    end

    # Blog Example
    # Controller -> Resque.enqueue(RailsBuild, @project.id)
    # Spec -> Resque.expects(:enqueue).with(RailsBuild, project.id).once
      

    context "user is valid" do
      xit "welcome email is enqueued" do
        post :create, valid_attributes
        Resque.stubs(:enqueue)
        Resque.expects(:enqueue).with(WelcomeEmailJob, @user.email, @user.full_name).once
      end
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
