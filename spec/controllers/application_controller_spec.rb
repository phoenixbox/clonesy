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
