require File.dirname(__FILE__) + '/../spec_helper'

describe Order do

  let(:user){ FactoryGirl.create(:user_2) }
  let(:product){ FactoryGirl.build(:product) }
  let(:cart_contents) { {product.store_id => {product.id => 1} } }
  let(:cart){ SessionCart.new(cart_contents, product.store) }
  let(:order){ FactoryGirl.build(:order) }
  let!(:store) {FactoryGirl.create(:store)}

  before(:each) do
    order.user_id = user.id
    order.save! 

    product.store_id = store.id
    product.save!

  
  end

  it 'has a valid factory' do
    expect(FactoryGirl.build(:order, user: user)).to be_valid
  end

  it 'is invalid without a user' do
    expect(FactoryGirl.build(:order, user: nil)).to_not be_valid
  end

  it 'is invalid without a valid status' do
    expect(FactoryGirl.build(:order, user: user, status: 'pending')).to be_valid
    expect(FactoryGirl.build(:order, user: user, status: 'cancelled')).to be_valid
    expect(FactoryGirl.build(:order, user: user, status: 'paid')).to be_valid
    expect(FactoryGirl.build(:order, user: user, status: 'shipped')).to be_valid
    expect(FactoryGirl.build(:order, user: user, status: 'returned')).to be_valid
    expect(FactoryGirl.build(:order, user: user, status: nil)).to_not be_valid
    expect(FactoryGirl.build(:order, user: user, status: 'abracadabra')).to_not be_valid
  end


  context "when orders exist" do 

    it "returns orders by status" do 
      expect((Order.by_status("pending")).count).to eq 1
    end
  end

  context "when an order has been placed" do 

    it "creates a pending order" do 
      expect{
        Order.create_pending_order(user, cart)
        }.to change{ Order.count}.by(1)
      expect(Order.first.status).to eq "pending"
    end
  end

  context "when an order exists" do 

    it "updates its status" do 
      order.update_status
      expect(order.status).to eq 'cancelled'
    end
  end

  context "for an existing order" do 

    it "returns its total with no items" do
      expect(order.total).to eq 0
    end

    it "returns its total with items" do 
      order = Order.create_pending_order(user, cart)
      expect(order.total).to eq 12.99
    end
  end
end