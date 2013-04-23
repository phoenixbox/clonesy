require 'spec_helper'

describe ApplicationController do
  describe 'require_admin' do
    context 'when current store is nil' do
      it 'not authenticated' do
        controller.stub(:current_store).and_return(nil)
        controller.should_receive(:not_authenticated)
        controller.require_admin
      end
    end

    context 'when current user is not an admin of the store' do
      it 'not authenticated' do
        mock_store = mock('Current Store', is_admin?: false)
        controller.stub(:current_store).and_return(mock_store)
        controller.should_receive(:not_authenticated)
        controller.require_admin
      end
    end

    context 'when current user is an admin of the store' do
      it 'does not raise not authenticated' do
        mock_store = mock('Current Store', is_admin?: true)
        controller.stub(:current_store).and_return(mock_store)
        controller.should_not_receive(:not_authenticated)
        controller.require_admin
      end
    end
  end

  describe 'require_uber' do
    it 'when false raises not authenticated' do
      mock_user = mock('Current User', uber?: false)
      controller.stub(:current_user).and_return(mock_user)
      controller.should_receive(:not_authenticated)
      controller.require_uber
    end

    it 'passes when uber' do
      mock_user = mock('Current User', uber?: true)
      controller.stub(:current_user).and_return(mock_user)
      controller.should_not_receive(:not_authenticated)
      controller.require_uber
    end
  end

  describe 'not_authenticated' do
    it 'redirects user' do
      controller.should_receive(:redirect_to)
      controller.not_authenticated
    end
  end

  describe 'require_current_store' do
    it 'raises RoutingError if no store' do
      expect { controller.require_current_store }.to raise_error
    end

    it 'passes when current store exists' do
      controller.stub(:current_store => true)
      expect { controller.require_current_store }.to_not raise_error
    end
  end

  describe 'flag' do
    it 'returns the correct flag' do
      session[:i18n] = 'en'
      expect(@controller.flag).to eq 'us'
      session[:i18n] = 'fr'
      expect(@controller.flag).to eq 'fr'
      session[:i18n] = 'cs'
      expect(@controller.flag).to eq 'cs'
    end
  end
end
