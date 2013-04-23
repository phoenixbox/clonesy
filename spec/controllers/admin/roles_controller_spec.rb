require 'spec_helper'

describe Admin::RolesController do
  let!(:store){FactoryGirl.create(:store)}
  let!(:admin){FactoryGirl.create(:user)}
  let!(:user){FactoryGirl.create(:user,
              full_name: "Fake User",
              email: "fake@user.com")}

  before (:each) do
    controller.stub(:require_admin => true)
    controller.stub(:current_user => admin)
    controller.stub(:current_store => store)
  end

  context "admin creates a new role for user" do
    it "if email is blank, redirects, no user promoted" do
      post :create, {user: {role: 'admin'}}, store_path: store.path
      expect(store.is_admin?(user)).to be false
      expect(page).to redirect_to store_admin_manage_path(store)
    end

    it "if email exists in DB, promotes user" do
      controller.stub(:enqueue_role_confirm)
      post :create, {user: {role: 'admin', email: "fake@user.com"}}, store_path: store.path
      expect(store.is_admin?(user)).to be true
    end

    it "if email does not exist, invites new user via email" do
      controller.stub(:enqueue_role_invite)
      post :create, {user: {role: 'admin', email: "not@inDB.com"}}, store_path: store.path
      expect(page).to redirect_to store_admin_manage_path(store)
    end
  end

  context "admin destroys role for user" do
    it "destroys role for user" do
      Role.promote(user, store, 'admin')
      expect(store.is_admin?(user)).to be true
      controller.stub(:enqueue_role_revoke)
      delete :destroy, { user_id: user.id }, store_path: store.path
      expect(store.is_admin?(user)).to be false
    end
  end
end