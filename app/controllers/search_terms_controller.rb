class SearchTermsController < ApplicationController
  def results
    product = SearchTerms.match_by_title(params[:query])
    if product
      redirect_to store_product_path(product.store, product)
    else
      redirect_to root_path,
        notice: "No product results found."
      end
  end
end