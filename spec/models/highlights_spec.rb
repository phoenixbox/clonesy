require 'spec_helper'

describe Highlights do
  describe '.from_database' do
    it 'primes Product.featured' do
      Product.stub(:featured).and_return('featured products')
      highlights = Highlights.from_database
      expect(highlights.featured_products).to eq 'featured products'
    end

    it 'primes Product.recent' do
      Product.stub(:recent).and_return('recent products')
      highlights = Highlights.from_database
      expect(highlights.recent_products).to eq 'recent products'
    end

    it 'primes Store.featured' do
      Store.stub(:featured).and_return('featured store')
      highlights = Highlights.from_database
      expect(highlights.featured_store).to eq 'featured store'
    end

    it 'primes Store.recent' do
      Store.stub(:recent).and_return('recent store')
      highlights = Highlights.from_database
      expect(highlights.recent_store).to eq 'recent store'
    end
  end
end
