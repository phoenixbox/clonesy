require 'spec_helper'

describe SearchTerms do
  describe "self.list" do
    it "returns an array" do
      expect(SearchTerms.list).to be_kind_of Array
    end

    it "contains list of product titles" do
      product = FactoryGirl.create(
                          :product,
                          store: FactoryGirl.create(:store))
      expect(SearchTerms.list).to include product.title
    end
  end
end