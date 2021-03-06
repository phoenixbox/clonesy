require File.dirname(__FILE__) + '/../spec_helper'

describe OrderItem do
  let!(:user){FactoryGirl.create(:user)}
  let!(:store){FactoryGirl.create(:store)}
  let!(:product){FactoryGirl.create(:product, store: store)}
  let!(:order){FactoryGirl.create(:order, user: user)}

  it 'has a valid factory' do
    expect(FactoryGirl.build(:order_item, order: order, product: product)).to be_valid
  end

  it 'is invalid without a product' do
    expect(FactoryGirl.build(:order_item, product: nil)).to_not be_valid
  end

  it 'is invalid without an order' do
    expect(FactoryGirl.build(:order_item, order: nil)).to_not be_valid
  end

  it 'is invalid without a valid unit price' do
    expect(FactoryGirl.build(:order_item, unit_price: nil,
            order: order, product: product)).to_not be_valid
    expect(FactoryGirl.build(:order_item, unit_price: 0,
            order: order, product: product)).to_not be_valid
    expect(FactoryGirl.build(:order_item, unit_price: 1.245,
            order: order, product: product)).to_not be_valid
    expect(FactoryGirl.build(:order_item, unit_price: 1.24,
            order: order, product: product)).to be_valid
  end

  it 'is invalid without an integer quantity above zero' do
    expect(FactoryGirl.build(:order_item, quantity: nil)).to_not be_valid
    expect(FactoryGirl.build(:order_item, quantity: 0)).to_not be_valid
    expect(FactoryGirl.build(:order_item, quantity: 1.5)).to_not be_valid
  end
end
