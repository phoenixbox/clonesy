require 'spec_helper'

describe SearchTerms do
  let(:store){FactoryGirl.create(:store)}
  let!(:product){FactoryGirl.create(:product, store: store)}

  describe "self.list" do
    it "returns an array" do
      expect(SearchTerms.list).to be_kind_of Array
    end

    it "contains list of product titles" do
      expect(SearchTerms.list).to include product.title
    end
  end

  describe "self.match_by_title" do
    it "returns a product of matching title" do
      result = SearchTerms.match_by_title(product.title)
      expect(result).to eq product
    end

    it "returns product given case insensitive segment of title" do
      query = product.title.upcase[0..2]
      result = SearchTerms.match_by_title(query)
      expect(result).to eq product
    end
  end
end