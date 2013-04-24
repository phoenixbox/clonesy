require 'spec_helper'

describe Cart do
  let!(:store){FactoryGirl.create(:store)}
  let!(:p){FactoryGirl.create(:product, store: store)}

  context "cart with one product, p" do
    before (:each) do
      session = {}
      session[:cart] = {p.id => '2'}
      @cart = Cart.new(session[:cart])
    end

    it 'has items with product and quantity' do
      expect(@cart.items.first.product).to eq p
      expect(@cart.items.first.quantity).to eq '2'
    end

    it 'has a total price equal to the price by quantity of products in cart' do
      expect(@cart.total).to eq (p.price * 2)
    end

    it 'can remove the only item, resulting in an empty cart' do
      expect(@cart).to_not be_empty
      @cart.remove_item(p.id)
      expect(@cart).to be_empty
    end

    it 'can destroy the cart, which resets data to an empty hash' do
      expect(@cart).to_not be_empty
      @cart.destroy
      expect(@cart).to be_empty
    end

    it 'can update the quantity in the cart' do
      @cart.update(product_id: p.id, quantity: '5')
      expect(@cart.items.first.quantity).to eq '5'
    end

    it 'cannot update the quantity in the cart to a negative number' do
      @cart.update(product_id: p.id, quantity: '-7')
      expect(@cart.items.first.quantity).to eq '2'
    end

    it 'counts total items (quantity) and produces string' do
      expect(@cart.count).to eq "(2)"
    end

    it 'empty? returns true or false based on items == 0' do
      expect(@cart.empty?).to eq false
      cart2 = Cart.new({})
      expect(cart2.empty?).to eq true
    end
  end
end
