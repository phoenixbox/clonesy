require 'spec_helper'

describe Uber::StoresController do

  before(:each) do
    controller.stub(:require_uber => true)
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns the correct stores to instance variable' do
      store = FactoryGirl.create(:store)
      get :index
      assigns(:stores).should eq([store])
    end

    it 'does not assign declined stores to the instance variable' do
      store = FactoryGirl.create(:store, status: 'declined')
      get :index
      assigns(:stores).should eq([])
    end
  end

  describe 'PUT #approve' do
    it 'approves the store when found' do
      store = FactoryGirl.create(:store, status: 'pending')
      put :approve, id: store.id
      store.reload
      expect(store.status).to eq('online')
    end

    it 'raises exception when not found' do
      expect {put :approve, id: 1 }.to raise_error
    end
  end

  describe 'PUT #decline' do
    it 'declines the store when found' do
      store = FactoryGirl.create(:store, status: 'pending')
      put :decline, id: store.id
      store.reload
      expect(store.status).to eq('declined')
    end

    it 'raises exception when not found' do
      expect {put :approve, id: 1 }.to raise_error
    end
  end

  describe 'PUT #toggle_online_status' do
    it 'toggles online to offline' do
      store = FactoryGirl.create(:store, status: 'online')
      put :toggle_online_status, id: store.id
      store.reload
      expect(store.status).to eq('offline')
    end

    it 'toggles online to offline' do
      store = FactoryGirl.create(:store, status: 'offline')
      put :toggle_online_status, id: store.id
      store.reload
      expect(store.status).to eq('online')
    end

    it 'redirects to uber_stores_path' do
      store = FactoryGirl.create(:store, status: 'offline')
      put :toggle_online_status, id: store.id
      expect(response).to redirect_to(uber_stores_path)
    end

    it 'raises exception when not found' do
      expect {put :toggle_online_status, id: 1 }.to raise_error
    end
  end
end
