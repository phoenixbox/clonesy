require 'spec_helper'

describe Cart do
  context 'new' do
    before (:each) do
      @store = FactoryGirl.create(:store)
    end

    it 'has items' do
      product = FactoryGirl.create(:product, store: @store)
      session = {}
      session[:cart] = {product.id => '2'}
      cart = Cart.new(session[:cart])
      expect(cart.items.first.product).to eq product
      expect(cart.items.first.quantity).to eq '2'
    end
  end
end
