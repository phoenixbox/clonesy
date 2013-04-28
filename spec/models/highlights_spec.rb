require 'spec_helper'

describe Highlights do
  describe '.from_database' do
    before(:each) do
      Product.stub(:popular).and_return('popular products')
      Product.stub(:recent).and_return('recent products')
      Store.stub(:popular).and_return('popular store')
      Store.stub(:recent).and_return('recent store')
    end

    it 'primes Product.popular' do
      highlights = Highlights.from_database
      expect(highlights.popular_products).to eq 'popular products'
    end

    it 'primes Product.recent' do
      highlights = Highlights.from_database
      expect(highlights.recent_products).to eq 'recent products'
    end

    it 'primes Store.popular' do
      highlights = Highlights.from_database
      expect(highlights.popular_store).to eq 'popular store'
    end

    it 'primes Store.recent' do
      highlights = Highlights.from_database
      expect(highlights.recent_store).to eq 'recent store'
    end
  end
end
