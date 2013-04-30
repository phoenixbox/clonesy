require 'spec_helper'

describe LocalStore do

  # let(:mock_redis){ MockRedis.new }

  describe "#unique_user" do 

    let!(:store) { FactoryGirl.create(:store) }

    context "given a user is not unique" do 

      before do
        LocalStore.stub(:visited?).and_return(true) 
      end

      it "returns false" do 
        user_ip = "10.0.0.0" 
        expect(LocalStore.unique_user?(store, user_ip)).to be_false
      end
    end

    context "given a user is unique" do 

      before do 
        LocalStore.stub(:visited?).and_return(false)
        REDIS.stub(:sadd).and_return(true)
      end

      it "returns true" do 
        user_ip = "10.0.0.0" 
        expect(LocalStore.unique_user?(store, user_ip)).to be_true
      end
    end
  end

  describe "increasing a store's popularity" do 

    let(:store) { FactoryGirl.create(:store) }

    context "given the user has already visited the store's page" do 
      it "does not increase that store's popularity" do 
      end
    end

    context "given the user has not already visited the store's page" do 
      it "increases that store's popularity" do 
      end
    end
  end

  describe "increasing a product's popularity" do 

    let(:product) { FactoryGirl.create(:product) }

    context "given the user has already visited the product's page" do 
      it "does not increase that product's popularity" do 
      end
    end

    context "given the user has not already visited the product's page" do 
      it "increases that product's popularity" do 
      end
    end
  end

  xit '.increase_popularity' do
  end

  xit '.popular' do
  end
end
