require 'spec_helper'

describe SearchTermsController do
  describe "#results" do
    let(:store) { FactoryGirl.create(:store) }
    let!(:product) { FactoryGirl.create(:product, store: store) }

    context "if product exists" do
      it "directs user to product page" do
        post :results, query: "#{product.title}"
        expect(page).to redirect_to store_product_path(store, product)
      end
    end

    context "if product does not exist" do
      it "redirects user to root url" do
        post :results, query: "some other product"
        expect(page).to redirect_to root_path
      end
    end
  end
end