require 'spec_helper'

describe ApplicationController do
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
