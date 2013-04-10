require 'spec_helper'

describe 'Checkout flow' do
  context 'as an anonymous user' do
    xit 'offers three options upon clicking checkout' do
    end

    context 'presented with the three options' do
      xit 'selecting login will send to login and redirect with cart intact' do
      end

      xit 'selecting signup will send to signup and redirect with cart intact' do
      end

      xit 'selecting anonymous checkout will prompt checkout page' do
      end
    end
  end

  context 'as an authenticated user' do
    xit "will direct user to the checkout page" do
    end

    context 'on the checkout page' do
      xit 'will present saved addresses' do
      end

      xit 'will present saved credit cards' do
      end

      xit 'will have email field pre-filled' do
      end
    end
  end
end
