require File.dirname(__FILE__) + '/../spec_helper'

describe Product do
  before (:each) do
    @store = FactoryGirl.create(:store)
  end

  it 'has a valid factory' do
    expect(FactoryGirl.create(:product, store: @store)).to be_valid
  end

  it 'is invalid without a title' do
    expect(FactoryGirl.build(:product, store: @store, title: '')).to_not be_valid
  end

  it 'is invalid without a description' do
    expect(FactoryGirl.build(:product, store: @store, description: '')).to_not be_valid
  end

  it 'is invalid if title already exists (case insensitive)' do
    FactoryGirl.create(:product, title: 'shane', store: @store)
    product = FactoryGirl.build(:product, title: 'Shane', store: @store)
    expect(product.valid?).to be_false
  end

  it 'is invalid without a price' do
    expect(FactoryGirl.build(:product, store: @store, price: nil)).to_not be_valid
  end

  it 'is invalid without a price greater than 0' do
    expect(FactoryGirl.build(:product, store: @store, price: 0)).to_not be_valid
  end

  it 'is only valid with two or less decimal points' do
    expect(FactoryGirl.build(:product, store: @store, price: 0.123)).to_not be_valid
    expect(FactoryGirl.build(:product, store: @store, price: 0.10)).to be_valid
    expect(FactoryGirl.build(:product, store: @store, price: 0.1)).to be_valid
    expect(FactoryGirl.build(:product, store: @store, price: 2)).to be_valid
  end

  it 'is invalid without a status' do
    expect(FactoryGirl.build(:product, store: @store, status: nil)).to_not be_valid
  end

  it 'is invalid with a status other than active or retired' do
    expect(FactoryGirl.build(:product, store: @store, status: 'active')).to be_valid
    expect(FactoryGirl.build(:product, store: @store, status: 'retired')).to be_valid
    expect(FactoryGirl.build(:product, store: @store, status: 'something')).to_not be_valid
  end

  it 'has the ability to be assigned to multiple categories' do
    nicknacks = FactoryGirl.create(:category, title: 'nicknacks')
    superheroes = FactoryGirl.create(:category, title: 'superheroes')
    product = FactoryGirl.create(:product, store: @store, categories: [nicknacks, superheroes])
    expect(product.categories.count).to eq 2
  end

  describe '.featured_products' do
    it 'assigns four random products from a random store' do
      Store.stub(:find).and_return(@store)
      p1 = FactoryGirl.create(:product, store: @store)
      p2 = FactoryGirl.create(:product, store: @store)
      p3 = FactoryGirl.create(:product, store: @store)
      p4 = FactoryGirl.create(:product, store: @store)
      expect(Product.featured).to match_array [p1, p2, p3, p4]
    end
  end

  describe '.recent' do
    it 'assigns twelve most recent products from all stores' do
      Store.stub(:find).and_return(@store)
      stores = []
      (1..12).each do |i|
        stores << FactoryGirl.create(:product, store: @store)
      end
      expect(Product.recent).to match_array stores
    end
  end

  describe '.toggle_status' do
    context 'on an active product' do
      it 'sets the status from active to retired' do
        product = FactoryGirl.create(:product, store: @store, status: 'active')
        product.toggle_status
        expect(product.status).to eq 'retired'
      end
    end

    context 'on a retired product' do
      it 'sets the status to active' do
        product = FactoryGirl.create(:product, store: @store, status: 'retired')
        product.toggle_status
        expect(product.status).to eq 'active'
      end
    end
  end

  describe 'self.category id' do
    context "on a product with a category_id" do
      it "finds the products by the category_id" do
        nicknacks = FactoryGirl.create(:category, title: 'nicknacks')
        product1 = FactoryGirl.create(:product, store: @store, categories: [nicknacks] )
        product2 = FactoryGirl.create(:product, store: @store, categories: [nicknacks] )
        product3 = FactoryGirl.create(:product, store: @store)
        expect(Product.by_category(nicknacks.id)).to eq [product1, product2]
      end
    end

    context "on a product without a category_id" do
      it "doesn't apply a category filter" do
        nicknacks = FactoryGirl.build(:category, title: 'nicknacks')
        product1 = FactoryGirl.create(:product, store: @store)
        product2 = FactoryGirl.create(:product, store: @store)
        product3 = FactoryGirl.create(:product, store: @store)
        expect(Product.by_category(nicknacks.id)).to match_array [product1, product2, product3]
      end
    end

  end
end
